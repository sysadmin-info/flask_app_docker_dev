FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    openssh-server sudo python3 python3-pip mysql-server libmysqlclient-dev && \
    mkdir /var/run/sshd && echo 'root:root' | chpasswd

# Allow root login over SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Create directory for init scripts
RUN mkdir -p /docker-entrypoint-initdb.d

# Copy the initialization SQL script
COPY init.sql /docker-entrypoint-initdb.d/

# Copy the Flask app
COPY app.py /app/app.py

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the working directory for Flask
WORKDIR /app

# Expose necessary ports
EXPOSE 22 5000

# Install Python dependencies
RUN pip3 install flask mysql-connector-python

# Use entrypoint script to manage MySQL and Flask startup
ENTRYPOINT ["/entrypoint.sh"]

# Default CMD to run Flask's built-in development server
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]

