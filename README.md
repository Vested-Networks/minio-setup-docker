
# 🚀 MinIO Setup with Docker and NGINX

This repository contains a minimal and scalable setup for running a **MinIO** distributed object storage cluster using **Docker Compose** and **NGINX** as a reverse proxy.

---

## 📦 What's Included

* **MinIO Cluster** (2 nodes by default, scalable)
* **NGINX Reverse Proxy** for load balancing
* Sample **lifecycle rule** to auto-delete temporary files
* Persistent **volume mounts**

---

## 📁 Directory Structure

```
.
├── .data/                 # Persistent storage volume
├── docker-compose.yml     # Main MinIO + NGINX setup
├── nginx.conf             # NGINX reverse proxy config
└── README.md              # This file
```

---

## 🛠️ How to Use

1. **Clone the repository**

   ```bash
   git clone git@github.com:Vested-Networks/minio-setup-docker.git
   cd minio-setup-docker
   ```

2. **Start the MinIO cluster**

   ```bash
   docker-compose up -d
   ```

3. **Access MinIO:**

   * S3-compatible API: [http://localhost:9000](http://localhost:9000)
   * Admin Console: [http://localhost:9001](http://localhost:9001)

4. **Default Credentials:**

   ```
   Username: admin
   Password: changeme
   ```

---

## 📥 Download MinIO client

```bash
sudo wget -O /usr/local/bin/mc https://dl.min.io/client/mc/release/linux-amd64/mc
sudo chmod +x /usr/local/bin/mc
mc --help
```

---

## 🧹 Lifecycle Rule (Auto-Delete)

To auto-delete files older than 1 day in the `temporary/` folder of a bucket, follow the guide in the main blog post or use:

```bash
mc alias set local http://localhost:9000 admin changeme
mc ilm rule add local/yourbucket --expire-days 1 --prefix "temporary/"
```

---

## 👮 Policy files

To set up access rules from a json policy file, use:

```bash
# Create a bucket
mc mb local/yourbucket

# Set bucket permissions <download|upload|public>
mc anonymous set download local/yourbucket

# Load permissions from policy file
mc anonymous set-json bucket-policy.json local/yourbucket

```

Contents of `bucket-policy.json`:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": ["*"]
      },
      "Action": ["s3:GetObject"],
      "Resource": "arn:aws:s3:::*/*"
    },
    {
      "Effect": "Deny",
      "Principal": {
        "AWS": ["*"]
      },
      "Action": ["s3:ListBucket"],
      "Resource": "arn:aws:s3:::*"
    }
  ]
}

```

---

## 📌 Notes

* You can scale MinIO instances by modifying the `docker-compose.yml` file.
* If scaling beyond 2 nodes, **update `nginx.conf`** accordingly.
* The NGINX config is designed for basic load balancing; customize as needed.

---

## 📎 Reference

📝 Blog: [Blog](https://ragug.medium.com/setting-up-minio-with-docker-an-open-source-alternative-to-aws-s3-ba92a052576e)
🔗 Original NGINX Config & Full Setup: [GitHub Repository](https://github.com/Raguggg/minio-setup-docker)

---
