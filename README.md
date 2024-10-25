---

# Flask App Development Environment with Docker and Ansible on Debian 12

This project sets up a Flask application connected to a MySQL database in a development environment using Docker on a host with Debian 12. Ansible automates the setup by installing Docker locally, building the Docker image, and running the Flask app in a Docker container with MySQL.

## Project Structure

- **`app.py`**: The Flask application that connects to a MySQL database and provides basic API endpoints.
- **`Dockerfile`**: Defines the Docker image, including installing dependencies, copying application files, and setting up the environment.
- **`entrypoint.sh`**: Entrypoint script to initialize MySQL, set up the database, and run the Flask app within the Docker container.
- **`init.sql`**: SQL script to initialize the MySQL database with schema and sample data for testing.
- **`app.yml`**: Ansible playbook to install Docker locally, build the Docker image, and run the container.

## File Details

### `app.py`

The main Flask application, with the following configurations and routes:

- **MySQL Configuration**: Reads MySQL details from environment variables:
  - `MYSQL_DATABASE_HOST`: Defaults to `127.0.0.1`
  - `MYSQL_DATABASE_USER`: Defaults to `db_user`
  - `MYSQL_DATABASE_PASSWORD`: Defaults to `Passw0rd`
  - `MYSQL_DATABASE_DB`: Defaults to `employee_db`

- **Routes**:
  - `/`: Basic welcome message.
  - `/how_are_you`: Returns a friendly message.
  - `/read_from_database`: Connects to MySQL and retrieves employee names from the `employees` table.

### `Dockerfile`

Defines the Docker image setup:

1. **Base Image**: Uses Python as the base for Flask and MySQL libraries.
2. **Install Dependencies**: Installs required system packages and Python libraries.
3. **Set Up Environment**: Configures MySQL connection variables.
4. **Copy Files**: Adds `app.py`, `entrypoint.sh`, and `init.sql` to the container.
5. **Entrypoint**: Sets `entrypoint.sh` to run when the container starts.

### `entrypoint.sh`

The entrypoint script initializes the MySQL database and starts the Flask app:

1. **Start MySQL**: Launches MySQL within the container and waits until it’s fully up.
2. **Initialize Database**: Executes `init.sql` to set up the database and sample data.
3. **Run Flask**: Starts the Flask development server on `0.0.0.0:5000`.

### `init.sql`

SQL script that:

- **Creates Database**: Sets up `employee_db`.
- **Creates Table**: Defines the `employees` table with columns for `id`, `name`, `position`, and `salary`.
- **Inserts Sample Data**: Adds initial employee records for testing.

### `app.yml`

The Ansible playbook to automate Docker setup on the local machine, build the Docker image, and run the container:

1. **Install Docker**: Installs Docker and Docker Compose locally.
2. **Build Docker Image**: Uses the `Dockerfile` to build the image from the project directory.
3. **Run Docker Container**: Starts the container, making Flask accessible at `0.0.0.0:5000`.

## Prerequisites

- Ansible installed on the local machine.
- `sudo` access on the local machine to install Docker and manage services.

## Setup and Deployment

1. **Prepare the Application Files**:
   Ensure all files (`app.py`, `Dockerfile`, `entrypoint.sh`, `init.sql`, and `app.yml`) are in the project directory on the local machine.

2. **Run the Ansible Playbook**:
   Deploy the application with:

   ```bash
   ansible-playbook app.yml
   ```

   The playbook will:
   - Install Docker on your local machine (if not already installed).
   - Build the Docker image from the project files.
   - Start the Flask app in a Docker container.

3. **Access the Application**:
   Once the playbook completes, open a web browser and go to:

   ```
   curl http://localhost:5000
   ```

   This connects to the Flask app running inside the Docker container.

4. **Stopping the Container**:
   If you need to stop the application, run:

   ```bash
   docker stop my_flask_mysql_container
   ```

---

This setup provides a complete development environment for the Flask app using Docker, with Ansible to manage local Docker setup and container deployment.