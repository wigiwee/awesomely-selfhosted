## Nextcloud - open-source cloud platform that lets you store, sync, and share files across devices

### step 1 - get the servers running
```bash
docker compose up -d
```

note: if u see this error on admin first login page then follow these steps ```Cannot create or write into the data directory /var/www/html/data```
```bash
docker exec -it nextcloud chown -R www-data:www-data /var/www/html
```

