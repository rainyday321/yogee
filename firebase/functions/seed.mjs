// Seeds the LOCAL Firebase emulator with dummy data.
// Refuses to run against production - the emulator host vars must be set.
//
//   npm run seed        (from firebase/functions)
//
// Field keys below match lib/backend/schema/*_record.dart exactly.

import admin from 'firebase-admin';

// Two targets:
//   npm run seed        -> local emulator, project demo-yoogee (wiped on restart)
//   npm run seed:dev    -> the dev CLOUD project yogee-e62e2 (persists)
//
// yoogeeapp (production) is NOT a target and must never become one: its
// firestore.rules set `allow delete: if false` on every collection, so anything
// written there cannot be removed by any client.
const DEV_PROJECT_ID = 'yogee-e62e2';
const EMULATOR_PROJECT_ID = 'demo-yoogee';

const useCloud = process.argv.includes('--cloud');
const PROJECT_ID = useCloud ? DEV_PROJECT_ID : EMULATOR_PROJECT_ID;

if (PROJECT_ID === 'yoogeeapp') {
  console.error('Refusing to seed production (yoogeeapp).');
  process.exit(1);
}

if (useCloud) {
  // Real Firebase. The Admin SDK needs Application Default Credentials; a
  // `firebase login` session is NOT ADC and will fail with "Could not load the
  // default credentials".
  //
  // Point GOOGLE_APPLICATION_CREDENTIALS at a service-account key:
  //   Firebase console -> Project settings -> Service accounts
  //   -> Generate new private key
  // Save it OUTSIDE the repo, then:
  //   $env:GOOGLE_APPLICATION_CREDENTIALS = "C:\path\to\key.json"
  //   npm run seed:dev
  delete process.env.FIRESTORE_EMULATOR_HOST;
  delete process.env.FIREBASE_AUTH_EMULATOR_HOST;
  if (!process.env.GOOGLE_APPLICATION_CREDENTIALS) {
    console.error('GOOGLE_APPLICATION_CREDENTIALS is not set.');
    console.error('Generate a service-account key for ' + PROJECT_ID + ', save it outside the repo, then:');
    console.error('  $env:GOOGLE_APPLICATION_CREDENTIALS = "C:\\path\\to\\key.json"');
    console.error('  npm run seed:dev');
    process.exit(1);
  }
  console.log(`Target: CLOUD project ${PROJECT_ID}`);
} else {
  process.env.FIRESTORE_EMULATOR_HOST ??= '127.0.0.1:8080';
  process.env.FIREBASE_AUTH_EMULATOR_HOST ??= '127.0.0.1:9099';

  // SAFETY for the emulator path: the host must be loopback, AND something must
  // actually be listening on it. Without the second check a stopped emulator
  // would let the Admin SDK silently fall through to real Firebase.
  if (!/^(127\.0\.0\.1|localhost):/.test(process.env.FIRESTORE_EMULATOR_HOST)) {
    console.error(`FIRESTORE_EMULATOR_HOST is "${process.env.FIRESTORE_EMULATOR_HOST}", not loopback. Refusing to seed.`);
    process.exit(1);
  }
  try {
    const probe = await fetch(`http://${process.env.FIRESTORE_EMULATOR_HOST}/`);
    if (!probe.ok) throw new Error(`status ${probe.status}`);
  } catch (e) {
    console.error(`No Firestore emulator answering on ${process.env.FIRESTORE_EMULATOR_HOST} (${e.message}).`);
    console.error('Refusing to seed. Start it with: npm run emulators');
    process.exit(1);
  }
}

admin.initializeApp({ projectId: PROJECT_ID });
const db = admin.firestore();
const auth = admin.auth();

const IMG = (seed, w = 600) => `https://picsum.photos/seed/${seed}/${w}/${w}`;
const MP3 = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

const USERS = [
  { uid: 'seeduser0000000000000000000001', email: 'demo@yogee.test', password: 'password123',
    display_name: 'Demo User', username: 'demouser', Bio: 'Seeded account for local dev.',
    from: 'Kuala Lumpur', currentlocation: 'Kuala Lumpur' },
  { uid: 'seeduser0000000000000000000002', email: 'maya@yogee.test', password: 'password123',
    display_name: 'Maya Chen', username: 'mayac', Bio: 'Morning meditation, always.',
    from: 'Singapore', currentlocation: 'Singapore' },
  { uid: 'seeduser0000000000000000000003', email: 'idris@yogee.test', password: 'password123',
    display_name: 'Idris Rahman', username: 'idrisr', Bio: 'Sleep stories and rain sounds.',
    from: 'Penang', currentlocation: 'Penang' },
];

const ARTISTS = [
  { id: 'seed_artist_1', artistname: 'Nature Sounds Collective',
    details: 'Field recordings from rainforests and coastlines.', image: IMG('artist1') },
  { id: 'seed_artist_2', artistname: 'Luna Sol',
    details: 'Ambient piano for sleep and focus.', image: IMG('artist2') },
  { id: 'seed_artist_3', artistname: 'The Breathing Room',
    details: 'Guided breathwork and body scans.', image: IMG('artist3') },
];

const ALBUMS = [
  { id: 'seed_album_1', album_name: 'Rainforest Mornings', artist: 'Nature Sounds Collective',
    description: 'Gentle rain and birdsong to start the day.', filter: 'Nature',
    cover_image: IMG('album1'), artistIdx: 0 },
  { id: 'seed_album_2', album_name: 'Deep Sleep Piano', artist: 'Luna Sol',
    description: 'Slow piano pieces for drifting off.', filter: 'Sleep',
    cover_image: IMG('album2'), artistIdx: 1 },
  { id: 'seed_album_3', album_name: 'Box Breathing', artist: 'The Breathing Room',
    description: 'Four-count breathwork sessions.', filter: 'Meditation',
    cover_image: IMG('album3'), artistIdx: 2 },
  { id: 'seed_album_4', album_name: 'Ocean at Night', artist: 'Nature Sounds Collective',
    description: 'Waves recorded on a quiet beach.', filter: 'Nature',
    cover_image: IMG('album4'), artistIdx: 0 },
  { id: 'seed_album_5', album_name: 'Focus Drones', artist: 'Luna Sol',
    description: 'Low ambient tones for deep work.', filter: 'Focus',
    cover_image: IMG('album5'), artistIdx: 1 },
];

const SONG_TITLES = [
  ['Dawn Chorus', 'Light Rain', 'Canopy Drip', 'Distant Thunder'],
  ['Nocturne in Blue', 'Slow Descent', 'Fading Light', 'Still Water'],
  ['Four Count', 'Body Scan', 'Evening Reset', 'Anchor Breath'],
  ['Low Tide', 'Shore Break', 'Midnight Swell', 'Salt Air'],
  ['Amber Drone', 'Long Field', 'Quiet Signal', 'Deep Work'],
];

async function wipe() {
  for (const c of ['users', 'artists', 'albums', 'songs', 'posts', 'playlists', 'usernames', 'comments']) {
    const snap = await db.collection(c).get();
    await Promise.all(snap.docs.map((d) => d.ref.delete()));
    if (snap.size) console.log(`  cleared ${snap.size} from ${c}`);
  }
}

// The emulator is disposable, so it always starts clean. A real project is
// not: wipe() deletes every document in the listed collections and there is no
// undo and no local copy. Every seed document uses a fixed id, so re-running
// without a wipe overwrites the seed rows in place and leaves everything else
// untouched. Pass --wipe to clear first, deliberately.
const allowWipe = !useCloud || process.argv.includes('--wipe');

async function seed() {
  console.log(useCloud
      ? `Seeding CLOUD project ${PROJECT_ID}`
      : `Seeding ${PROJECT_ID} via ${process.env.FIRESTORE_EMULATOR_HOST}`);
  if (allowWipe) {
    await wipe();
  } else {
    console.log('  skipping wipe (pass --wipe to clear collections first)');
  }

  // --- auth + users ---
  const userRefs = [];
  for (const u of USERS) {
    await auth.createUser({
      uid: u.uid, email: u.email, password: u.password, displayName: u.display_name,
    }).catch((e) => { if (e.code !== 'auth/uid-already-exists') throw e; });

    const ref = db.doc(`users/${u.uid}`);
    userRefs.push(ref);
    await ref.set({
      email: u.email, display_name: u.display_name, photo_url: IMG(u.username, 200),
      uid: u.uid, created_time: admin.firestore.Timestamp.now(),
      phone_number: '', username: u.username, Bio: u.Bio,
      from: u.from, currentlocation: u.currentlocation,
      following: [], followers: [], blocked: [],
      Interests: ['meditation', 'sleep', 'focus'], favsongs: [],
      announcement_notification: true, appupdate_notifications: true,
    });
    await db.doc(`usernames/${u.username}`).set({ username: u.username, uid: u.uid });
  }
  console.log(`  ${USERS.length} users (+ auth accounts)`);

  // --- artists ---
  const artistRefs = [];
  for (const a of ARTISTS) {
    const ref = db.doc(`artists/${a.id}`);
    artistRefs.push(ref);
    await ref.set({ artistname: a.artistname, details: a.details, image: a.image, albums: [] });
  }
  console.log(`  ${ARTISTS.length} artists`);

  // --- albums ---
  const albumRefs = [];
  for (const al of ALBUMS) {
    const ref = db.doc(`albums/${al.id}`);
    albumRefs.push(ref);
    await ref.set({
      album_name: al.album_name, description: al.description, cover_image: al.cover_image,
      filter: al.filter, artist: al.artist,
      artistref: [artistRefs[al.artistIdx]],
      playcount: userRefs.slice(0, 1 + (albumRefs.length % 3)),
    });
    await artistRefs[al.artistIdx].update({
      albums: admin.firestore.FieldValue.arrayUnion(ref),
    });
  }
  console.log(`  ${ALBUMS.length} albums`);

  // --- songs ---
  let songCount = 0;
  const songRefs = [];
  for (let i = 0; i < ALBUMS.length; i++) {
    for (let n = 0; n < SONG_TITLES[i].length; n++) {
      const ref = db.doc(`songs/seed_song_${i}_${n}`);
      songRefs.push(ref);
      await ref.set({
        title: SONG_TITLES[i][n], artist: ALBUMS[i].artist, album: albumRefs[i],
        songCoverImage: ALBUMS[i].cover_image, songUrl: MP3,
        duration: `${3 + (n % 4)}:${String(10 + n * 7).padStart(2, '0')}`,
        num: n + 1, liked_by: userRefs.slice(0, (n % 3)),
      });
      songCount++;
    }
  }
  console.log(`  ${songCount} songs`);

  // --- playlists ---
  const PLAYLISTS = [
    { name: 'Morning Reset', userIdx: 0, songs: songRefs.slice(0, 4) },
    { name: 'Sleep Tonight', userIdx: 0, songs: songRefs.slice(4, 8) },
    { name: 'Deep Focus', userIdx: 1, songs: songRefs.slice(16, 20) },
  ];
  for (let i = 0; i < PLAYLISTS.length; i++) {
    const p = PLAYLISTS[i];
    await db.doc(`playlists/seed_playlist_${i}`).set({
      playlist_name: p.name, user: userRefs[p.userIdx], songs: p.songs,
    });
  }
  console.log(`  ${PLAYLISTS.length} playlists`);

  // --- posts ---
  const POSTS = [
    { topic: 'Finally hit a 30 day streak. The box breathing sessions did it.', tags: ['streak', 'breathwork'] },
    { topic: 'Rainforest Mornings on repeat while working. Anyone else?', tags: ['focus', 'music'] },
    { topic: 'Does anyone journal right after meditating, or later in the day?', tags: ['journal'] },
    { topic: 'Deep Sleep Piano knocked me out in ten minutes last night.', tags: ['sleep'] },
    { topic: 'New here. What should I start with?', tags: ['newbie'] },
  ];
  const postRefs = [];
  for (let i = 0; i < POSTS.length; i++) {
    const ref = db.doc(`posts/seed_post_${i}`);
    postRefs.push(ref);
    await ref.set({
      date: admin.firestore.Timestamp.fromMillis(Date.now() - i * 86400000),
      poster: userRefs[i % userRefs.length],
      image: i % 2 === 0 ? IMG(`post${i}`, 800) : '',
      topic: POSTS[i].topic,
      likes: userRefs.slice(0, (i % 3)),
      tags: POSTS[i].tags,
    });
  }
  console.log(`  ${POSTS.length} posts`);

  // --- comments ---
  // Keys match lib/backend/schema/comments_record.dart. `postref` + `time` is
  // the composite index in firestore.indexes.json, which is what the replies
  // screen orders by.
  const COMMENTS = [
    ['Congrats, that is a real habit now.', 'Box breathing is underrated.', 'What time of day do you sit?'],
    ['Same, it is my default work album.'],
    ['Right after. Ten minutes, longhand.', 'Later for me - evenings.'],
    [],
    ['Start with Box Breathing, four minutes.', 'Welcome!', 'Sleep stories if you struggle at night.'],
  ];
  let commentCount = 0;
  for (let i = 0; i < postRefs.length; i++) {
    for (let n = 0; n < COMMENTS[i].length; n++) {
      await db.doc(`comments/seed_comment_${i}_${n}`).set({
        comment: COMMENTS[i][n],
        // Staggered after the post so "relative" timestamps read sensibly.
        time: admin.firestore.Timestamp.fromMillis(
            Date.now() - i * 86400000 + (n + 1) * 3600000),
        postref: postRefs[i],
        // Commenter is never the poster, so the notification path in
        // replies_widget.dart is exercised rather than short-circuited.
        userref: userRefs[(i + n + 1) % userRefs.length],
        likes: userRefs.slice(0, n % 3),
      });
      commentCount++;
    }
  }
  console.log(`  ${commentCount} comments`);

  console.log('\nDone. Log in with demo@yogee.test / password123');
}

seed().then(() => process.exit(0)).catch((e) => { console.error(e); process.exit(1); });
