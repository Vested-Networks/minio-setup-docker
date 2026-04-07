# 🚀 MinIO Setup - Single Node

This repository contains a minimal setup for running a **MinIO** object storage server using **Docker Compose**.

---

## 📦 What's Included

* **MinIO Server** (1 node)
* Sample **lifecycle rule** to auto-delete temporary files
* Persistent **volume mounts**

---

## 📁 Directory Structure

```
.
├── .data/                 # Persistent storage volume
├── docker-compose.yml     # Main MinIO + NGINX setup
└── README.md              # This file
```

---

## 🛠️ How to Use

1. **Clone the repository**

   ```bash
   git clone -b single-node git@github.com:Vested-Networks/minio-setup-docker.git
   cd minio-setup-docker
   ```

2. **Start the MinIO server**

   ```bash
   docker-compose up -d
   ```

3. **Access MinIO:**

   * S3-compatible API: [http://localhost:9900](http://localhost:9000)
   * Admin Console: [http://localhost:9901](http://localhost:9001)

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
mc alias set local http://localhost:9900 admin changeme
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

## 📎 Reference

📝 Blog: [Blog](https://ragug.medium.com/setting-up-minio-with-docker-an-open-source-alternative-to-aws-s3-ba92a052576e)
🔗 Original NGINX Config & Full Setup: [GitHub Repository](https://github.com/Raguggg/minio-setup-docker)

---
