# Authorized Thumbor with Envoy Proxy

A dockerized setup for Thumbor image processing service with JWT authentication via Envoy proxy.

## Overview

This project provides a secure image processing service using:
- **Thumbor**: On-demand image processing and transformation
- **Envoy Proxy**: JWT authentication and request routing
- **Docker Compose**: Easy deployment and orchestration

## Features

- 🔒 JWT-based authentication
- 🖼️ On-demand image processing and resizing
- 🚀 Containerized deployment
- 🔄 Load balancing and routing via Envoy
- 📁 File-based image storage

## Prerequisites

- Docker
- Docker Compose
- JWT provider with JWKS endpoint

## Quick Start

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd authorized_thumbor_dockerized
   ```

2. **Create environment file**
   ```bash
   cp .env.example .env
   ```

3. **Configure environment variables** in `.env`:
   ```env
   JWT_ISSUER=https://your-auth-provider.com
   JWKS_URI=https://your-auth-provider.com/.well-known/jwks.json
   JWKS_HOST=your-auth-provider.com
   ```

4. **Add your images**
   ```bash
   # Place your images in the images/ directory
   cp /path/to/your/images/* ./images/
   ```

5. **Start the services**
   ```bash
   docker-compose up -d
   ```

6. **Access the service**
   The service will be available at `http://localhost:8080`

## Configuration

### Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `JWT_ISSUER` | JWT token issuer | `https://auth.example.com` |
| `JWKS_URI` | JWKS endpoint URL | `https://auth.example.com/.well-known/jwks.json` |
| `JWKS_HOST` | JWKS host for SSL connection | `auth.example.com` |

### Thumbor Configuration

The Thumbor service is configured with:
- File loader for local images
- Security key: `MY_SECRET_KEY` (change in production)
- Unsafe URL mode enabled (disable in production)

## Usage

### Image Processing

Access images through Envoy proxy with JWT authentication:

```
GET http://localhost:8080/unsafe/300x200/path/to/your/image.jpg
```

**Note**: You need a valid JWT token in the `Authorization` header.

### Authentication

Include JWT token in requests:
```bash
curl -H "Authorization: Bearer YOUR_JWT_TOKEN" \
     http://localhost:8080/unsafe/300x200/test.png
```

## Project Structure

```
.
├── docker-compose.yml          # Docker Compose configuration
├── .env                       # Environment variables (create from .env.example)
├── .gitignore                # Git ignore rules
├── LICENSE                   # MIT License
├── envoy/                    # Envoy proxy configuration
│   ├── Dockerfile           # Envoy container build
│   ├── entrypoint.sh        # Envoy startup script
│   └── envoy.yaml.template  # Envoy configuration template
└── images/                   # Image storage directory
    ├── .gitkeep            # Keep directory in git
    └── test.png            # Sample image
```

## Services

### Thumbor
- **Port**: 8000 (internal)
- **Image**: `apsl/thumbor`
- **Volume**: `./images:/data/images:ro`

### Envoy Proxy
- **Port**: 8080 (exposed)
- **Build**: Custom image with JWT authentication
- **Features**: JWT validation, request routing

## Development

### Building Envoy Image

The Envoy service builds from [envoy/Dockerfile](envoy/Dockerfile):

```bash
docker-compose build envoy
```

### Configuration Template

Envoy configuration uses environment variable substitution via [envoy/envoy.yaml.template](envoy/envoy.yaml.template).

### Logs

View service logs:
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f envoy
docker-compose logs -f thumbor
```

## Security

- 🔐 JWT authentication required for all requests
- 🚫 Change default security key in production
- 🔒 Disable unsafe URL mode in production
- 🛡️ Configure proper CORS policies

## Production Deployment

For production use:

1. **Update security settings**:
   ```yaml
   environment:
     - ALLOW_UNSAFE_URL=False
     - SECURITY_KEY=your-production-secret-key
   ```

2. **Use proper SSL certificates**
3. **Configure resource limits**
4. **Set up monitoring and logging**
5. **Use secrets management**

## Troubleshooting

### Common Issues

1. **JWT validation fails**
   - Verify `JWT_ISSUER` and `JWKS_URI` are correct
   - Check network connectivity to JWKS endpoint

2. **Images not found**
   - Ensure images are in the `./images/` directory
   - Check file permissions

3. **Service startup issues**
   - Check environment variables in `.env`
   - Review logs: `docker-compose logs`

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

For more information about Thumbor, visit the [official documentation](https://thumbor.readthedocs.io/).