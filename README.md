# Muslit

Muslit is a self-hostable music library and discovery engine. It combines provider-backed catalog search, local audio ingestion, metadata extraction, lyrics lookup, safe direct-source downloads, transcoding, playlists and a persistent job queue.

## Important provider boundary
Spotify and YouTube integrations are **catalog/search integrations**. They return metadata and official playback URLs; they do not extract, decrypt, record or download protected streams. The downloader accepts only direct audio URLs on explicitly configured allowlisted hosts, where you have permission to download the media. Local imports are always supported.

## Requirements
- Node.js 22+
- FFmpeg and ffprobe on PATH
- npm

## Quick start
```sh
cp .env.example .env
npm install
npm run build
npm start
```
Open `http://127.0.0.1:8787/health`.

## Configuration
See [.env.example](.env.example). By default the server binds to loopback. Set `API_TOKEN` before exposing it to a network. Configure `DOWNLOAD_ALLOWED_HOSTS` with exact hostnames you control or trust. Spotify and YouTube catalog search require their respective API credentials.

## API
- `GET /health`
- `GET /api/search?q=...` (Spotify + YouTube catalog)
- `GET /api/search/spotify?q=...`
- `GET /api/search/youtube?q=...`
- `GET /api/lyrics?artist=...&track=...`
- `POST /api/import` multipart field `file`; optional `metadata` JSON field
- `POST /api/download` JSON `{ "url": "https://allowed-host/file.mp3", "metadata": {} }`
- `GET /api/library`, `GET /api/library/:id`
- `GET /api/tracks/:id/file`, `GET /api/tracks/:id/lyrics`
- `POST /api/tracks/:id/convert` JSON `{ "format": "mp3|flac|wav|opus|m4a" }`
- `GET /api/playlists`, `POST /api/playlists`, `GET /api/playlists/:id`, `POST /api/playlists/:id/tracks`
- `GET /api/queue`, `GET /api/queue/:id`

Mutating API routes require Bearer authentication when `API_TOKEN` is configured. Files are stored under `MUSLIT_DATA_DIR`; SQLite uses WAL mode. Jobs are persisted and run with bounded in-process concurrency.

## Development
```sh
npm run dev
npm test
npm run typecheck
npm run build
```

## License
MIT
