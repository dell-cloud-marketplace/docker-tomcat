docker run -d -p 8080:8080 --name tomcat \
-v /tomcat/logs:/opt/tomcat/logs \
-v /tomcat/work:/opt/tomcat/work \
-v /tomcat/webapps:/opt/tomcat/webapps \
dell/tomcat


# Apache Tomcat 8.0

A simple docker build for installing a vanilla Tomcat 8.0 below
*/opt/tomcat*. It comes out of the box and is intended for use for
integration testing.


During startup a directory specified by the environment variable `DEPLOY_DIR`
(*/maven* by default) is checked for .war files. If there
are any, they are linked into Jetty's *webapps/* directory for automatic
deployment. This plays nicely with the Docker maven plugin from
https://github.com/rhuss/docker-maven-plugin/ and its 'assembly' mode which
can automatically create Docker data container with Maven artifacts
exposed from a directory */maven*

This image will enable a Jolokia agent during startup which can be reached
by default within the container at port 8778.

The environment variable `$JOLOKIA_OFF` can be set so that the agent won't start.

More information about can be found in the description of jolokia/java-jolokia:7 [jolokia/java-jolokia:7](https://registry.hub.docker.com/u/jolokia/java-jolokia:7)

## Components
The stack comprises the following components:

Name              | Version                     | Description
------------------|-----------------------------|------------------------------
Apache Tomcat     | 8.0.9                       | Web Server
java-jolokia      | jolokia/java-jolokia:7      | OpenJDK


## Usage

### Basic Example
Start your image binding host port 8080 to port 8080 (Tomcat Web Server) in your container:

```no-highlight
docker run -d -p 8080:8080 -p 8778:8778 --name tomcat dell/tomcat
```

Test your deployment:

View the Tomcat site
```no-highlight
 at: http://localhost:8080/
```
Or test the response via CLI:

```no-highlight
curl http://localhost:8080/
```

## Administration

An admin user will be created in Tomcat with a random password. To get the password, check the container logs 

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
In this case, **PheiBe3Eidoh** is the password allocated to the admin user.

You can use the admin user to access the Tomcat manager: 
```no-highlight
http://localhost:8080/manager/
```
and Virtual Host manager: 
```no-highlight
http://localhost:8080/host-manager/
```

## Reference

### Image Details

Based on          | [ConSol/docker-appserver](https://github.com/ConSol/docker-appserver/tree/master/tomcat/8.0)

Pre-built Image   | [https://registry.hub.docker.com/u/dell/tomcat](https://registry.hub.docker.com/u/dell/tomcat) 
