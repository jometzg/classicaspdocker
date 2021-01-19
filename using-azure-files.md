# Working with files

## The problem of files
There is often the need for an application to deal with uploading files. Use cases include images for a product catalogue or thumbnails of users.
Applications generally do not store these images in a database - but merely use a database to reference an image that has been uploaded to the file system of the web server.

For container-based workloads this is no longer viable. Whilst the running container does have a file system (that is afterall where the code and HTML templates reside), any new additions to the contents of the container will be lost on a container restart. So, some other solution is needed.

## One solution
It is often not desirable to make larges changes to the code base of an existing application to accomodate this. The simplest method is to *mount* some more permanent storage into the container and to make sure the application writes to this.

Docker runtime has the ability to mount a volume into a container. This works both for Linux and for Windows containers. On a **docker run** commmand, this is using the *-v* parameter.

```
docker run -p8080:80 -v file-path:mount-point mycontainer
```

For a Windows container, an example of this could be:

```
docker run -p8080:80 -v C:\images:C:\mywebsite\files mycontainer
```

where the folder **C:\images** is mounted into the container at **C:\mywebsite/files**. In this manner, anything persisted during the use of the container into the C:\mywebsite\files will be persisted onto the host machine and therefore not lost when the container is stopped or restarted.



