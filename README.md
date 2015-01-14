# docker-tomcat
This image installs [Apache Tomcat](http://tomcat.apache.org/), an open source software implementation of the Java Servlet and JavaServer Pages technologies.

## Components
The software stack comprises the following components:

Name              | Version                     | Description
------------------|-----------------------------|------------------------------
Apache Tomcat     | 8.0.9                       | Web Server
Java JRE          | Latest supported version of 7 (see [docker-java-base-7](https://github.com/dell-cloud-marketplace/docker-java/blob/master/docker-java-base-7)) | Oracle Java Runtime Enviroment

## Usage

### Start the Container
If you wish to create data volumes, which will survive a restart or recreation of the container, please follow the instructions in [Advanced Usage](#advanced-usage).

#### Basic Usage
Start your container with:

 - A named container (**tomcat**).
 - Ports 8080 and 8443 (Tomcat HTTP and HTTPS traffic) exposed.

As follows:

```no-highlight
docker run -d -p 8080:8080 -p 8443:8443 --name tomcat dell/tomcat
```

<a name="advanced-usage"></a>
#### Advanced Usage
Start your container with:

- A named container (**tomcat**).
- Ports 8080 and 8443 (Tomcat HTTP and HTTPS traffic) exposed.
- 3 data volumes (which will survive a restart or recreation of the container). The Tomcat logs are available in **/tomcat/logs** on the host. The Tomcat work folder is **/tomcat/work**, and the web applications are in **/tomcat/webapps**, on the host.

As follows:

```no-highlight
sudo docker run -d \
    -p 8080:8080 \
    -p 8443:8443 \
    -v /tomcat/logs:/opt/tomcat/logs \
    -v /tomcat/work:/opt/tomcat/work \
    -v /tomcat/webapps:/opt/tomcat/webapps \
    --name tomcat \
    dell/tomcat
```

### Check the Container Logs
An admin user will be created in Tomcat with a random password. To get the password, check the container logs: 

```no-highlight
docker logs tomcat 
```

You will see output like the following:

```no-highlight
=========================================================================
You can now connect to this instance using:

    user name: admin
    password : PheiBe3Eidoh

========================================================================
```

Please make a secure note of this password (in this case, **PheiBe3Eidoh**).

### Test Your Deployment
To access the server, do:
```no-highlight
http://localhost:8080
```

Or use cURL:
```no-highlight
curl http://localhost:8080
```

The container supports SSL, via a self-signed certificate. **We strongly recommend that you connect via HTTPS**, if the container is running outside your local machine (e.g. in the Cloud). Your browser will warn you that the certificate is not trusted. If you are unclear about how to proceed, please consult your browser's documentation on how to accept the certificate.

```no-highlight
https://localhost:8443
```

### Administration Web Console
The Tomcat administration console can be accessed via the following URL:

```no-highlight
https://localhost:8443/manager
```

The user name is **admin**. The password is that read from the container logs.

#### Deploying a Sample Application
An example application can be downloaded from Apache [website](https://tomcat.apache.org/tomcat-8.0-doc/appdev/sample/).

From the administration console, scroll down to section **WAR file to deploy**. Click on the **Choose File** button, and select the download file (**sample.war**). Click on button **Deploy**. The application will be available at paths **http://localhost:8080/sample** and **http://localhost:8443/sample**.

## Reference

### Image Details
Based on | [ConSol/docker-appserver](https://github.com/ConSol/docker-appserver/tree/master/tomcat/8.0)

Pre-built Image | [https://registry.hub.docker.com/u/dell/tomcat](https://registry.hub.docker.com/u/dell/tomcat) 
