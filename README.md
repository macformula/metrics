# Racecar Telemetry & Metrics Platform

A full-stack telemetry and metrics platform for racecar data visualization and management. Built with FastAPI, React, InfluxDB, and Grafana, this system provides real-time data ingestion, storage, visualization, and user authentication.

## Architecture

The platform consists of several microservices:

- **Frontend**: React + TypeScript + Vite application
- **Backend API**: FastAPI server for data ingestion
- **Auth Service**: Separate authentication microservice with JWT tokens
- **InfluxDB**: Time-series database for telemetry data
- **Grafana**: Data visualization and dashboard service
- **Nginx**: Reverse proxy and SSL termination (production)

## Features

- **User Authentication**: JWT-based authentication with role-based access control (authorization levels)
- **Data Ingestion**: REST API endpoints for writing telemetry data to InfluxDB
- **Real-time Visualization**: Embedded Grafana dashboards for data visualization
- **Authorization Levels**: Level-based permissions (Level 5 required for write operations)
- **Secure Production Deployment**: SSL/TLS support with Let's Encrypt integration
- **Rate Limiting**: API rate limiting to prevent abuse

## Getting Started

### Prerequisites

- Docker and Docker Compose
- Node.js (for local frontend development)
- Python 3.x (for local backend development)

### Development Setup

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd metrics
   ```

2. **Create environment file**
   Create a `.env` file in the root directory, follow .env.example
3. **Start all services**

   ```bash
   docker-compose up -d
   ```

4. **Access the services**
   - Frontend: http://localhost:5173
   - Backend API: http://localhost:8000
   - Auth Service: http://localhost:8001
   - Grafana: http://localhost:3000
   - InfluxDB: http://localhost:8086

### Production Deployment

1. **Configure SSL certificates**

   ```bash
   ./init-letsencrypt.sh
   ```

2. **Start production services**

   ```bash
   docker-compose -f docker-compose-prod.yml up -d
   ```

3. **Access via HTTPS**
   - Application: https://your-domain.com
   - API: https://your-domain.com/api/
   - Auth: https://your-domain.com/auth/

## API Endpoints

### Authentication Service (Port 8001)

- `POST /register` - Register a new user

  ```json
  {
    "username": "string",
    "password": "string"
  }
  ```

- `POST /login` - Login and receive JWT token

  ```json
  {
    "username": "string",
    "password": "string"
  }
  ```

- `GET /me` - Get current user information (requires authentication)

### Backend API (Port 8000)

All endpoints require authentication and authorization level 5.

- `POST /write` - Write custom data point to InfluxDB

  ```json
  {
    "measurement": "string",
    "tags": { "key": "value" },
    "fields": { "key": "value" }
  }
  ```

- `POST /write-graph` - Write graph data point

  ```json
  {
    "timestamp": 1234567890,
    "value": 42.5
  }
  ```

- `POST /write-simple` - Write simple test message
  ```
  Query parameter: query=string
  ```

## Authorization Levels

The system uses a level-based authorization system:

- **Level 1**: Default level for new users (read-only access)
- **Level 5**: Required for write operations to InfluxDB

## Technology Stack

### Frontend

- React 19
- TypeScript
- Vite
- React Router
- TanStack Query

### Backend

- FastAPI
- Python 3
- InfluxDB Client
- SQLAlchemy
- JWT Authentication (python-jose)
- Uvicorn

### Infrastructure

- Docker & Docker Compose
- Nginx (reverse proxy)
- Let's Encrypt (SSL certificates)
- InfluxDB 2.x
- Grafana

## Project Structure

```
metrics/
├── backend/                # Backend API service
│   ├── server.py          # Main FastAPI application
│   ├── influx.py          # InfluxDB client utilities
│   ├── auth_utils.py      # JWT verification utilities
│   └── auth/              # Auth microservice
│       ├── app.py         # Auth FastAPI application
│       ├── models.py      # Database models
│       ├── database.py    # Database configuration
│       └── utils.py       # Auth utilities
├── frontend/              # React frontend
│   ├── src/
│   │   ├── components/    # React components
│   │   ├── contexts/      # React contexts (Auth)
│   │   ├── api/          # API client utilities
│   │   └── Pages/        # Page components
│   └── public/
├── nginx/                 # Nginx configuration
│   └── nginx.conf        # Production reverse proxy config
├── docker-compose.yml     # Development compose file
├── docker-compose-prod.yml # Production compose file
└── grafana.ini           # Grafana configuration
```

## Configuration

### InfluxDB

- Organization: `racecar`
- Bucket: `telemetry`
- Default admin credentials: `admin/password123` (change in production!)

### Grafana

- Default admin credentials: `admin/admin`
- Anonymous access enabled for viewers
- Embedding allowed for iframe integration

### Environment Variables

All sensitive configuration should be set via environment variables or `.env` file.

## Docker Services

### Development (`docker-compose.yml`)

- All ports exposed for direct access
- Hot-reload enabled for frontend and backend
- Volume mounts for live code updates

### Production (`docker-compose-prod.yml`)

- Services exposed only through Nginx reverse proxy
- SSL/TLS termination
- Automatic certificate renewal
- Rate limiting enabled

## Data Flow

1. User authenticates via `/auth/login` and receives JWT token
2. Frontend stores token and includes it in subsequent requests
3. Backend verifies token and authorization level
4. Authorized requests write data to InfluxDB
5. Grafana visualizes data from InfluxDB
6. Frontend embeds Grafana dashboards

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Troubleshooting

### InfluxDB Connection Issues

- Verify `INFLUXDB_TOKEN` and connection settings
- Check if InfluxDB container is running: `docker ps`
- View logs: `docker logs racecar-influxdb`

### Authentication Issues

- Ensure `SECRET_KEY` is consistent across backend and auth services
- Check auth service logs: `docker logs racecar-auth`
- Verify token is being sent in Authorization header

### Frontend Not Loading

- Check if all services are running: `docker-compose ps`
- Verify environment variables are set correctly
- Check browser console for errors

## Additional Resources

- [InfluxDB Documentation](https://docs.influxdata.com/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Grafana Documentation](https://grafana.com/docs/)
- [React Documentation](https://react.dev/)
