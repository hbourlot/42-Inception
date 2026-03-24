# 42 Inception — Study Workflow

This guide is a practical roadmap to study and build the Inception project (Docker + Nginx + WordPress + MariaDB).

## 1) Learning Phases

### Phase 1 — Docker foundations (1–2 days)
- Understand `Dockerfile`, images, containers, volumes, and networks.
- Learn `ENTRYPOINT` vs `CMD` and why PID 1 matters.
- Practice: build and run a tiny custom image.

### Phase 2 — Build services separately (2–3 days)
- MariaDB container only.
- WordPress with PHP-FPM only.
- Nginx container only.
- Practice: run each one alone and read logs.

### Phase 3 — Persistence (1 day)
- Configure named volumes for:
  - WordPress DB data
  - WordPress website files
- Understand named volumes vs bind mounts.
- Verify what survives container recreation.

### Phase 4 — Wire services together (2 days)
- Connect WordPress to MariaDB via environment variables/secrets.
- Configure Nginx FastCGI to send PHP requests to `wordpress:9000`.
- Serve static files correctly from Nginx.

### Phase 5 — TLS and security (1 day)
- Configure HTTPS on Nginx.
- Restrict protocols to `TLSv1.2` and `TLSv1.3` only.
- Use certificate + key (scripted generation preferred).

### Phase 6 — Reliability and reproducibility (1 day)
- Make startup scripts idempotent.
- Ensure `make`, `make clean`, and rebuilds work from zero.
- Keep config simple and explainable.

## 2) Daily Study Loop
- Read one section of the subject/spec (20–30 min).
- Implement one small piece (60–90 min).
- Validate with logs and commands (20–30 min).
- Write short notes: what failed, what fixed it (10–15 min).

## 3) Practical Validation Commands
- Start/rebuild:
  - `make`
- Stop/clean:
  - `make clean`
- Check running containers:
  - `docker ps`
- Check logs:
  - `docker logs nginx`
  - `docker logs wordpress`
  - `docker logs mariadb`
- Validate compose syntax:
  - `docker compose -f srcs/docker-compose.yml config`

## 4) Final Checklist Before Evaluation
- Services are isolated and communicate only through Docker network.
- MariaDB container contains MariaDB only.
- WordPress container uses PHP-FPM (no Apache image).
- Nginx container serves HTTPS with TLS 1.2/1.3 only.
- Two persistent named volumes are used:
  - DB volume
  - WordPress files volume
- Data persists across container recreation.
- Secrets and env variables are understood and documented.
- You can explain every port, volume, network, and startup script.

## 5) Suggested Explain-Back Practice
For each service, practice explaining in 20–30 seconds:
- Why it exists
- What it depends on
- Which volume it uses
- Which port/protocol it uses
- How to debug it quickly

If you can explain all three services clearly, you’re ready for defense 😁.
