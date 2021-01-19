# Working with files

## The problem of files
There is often the need for an application to deal with uploading files. Use cases include images for a product catalogue or thumbnails of users.
Applications generally do not store these images in a database - but merely use a database to reference an image that has been uploaded to the file system of the web server.

For container-based workloads this is no longer viable. Whilst the running container does have a file system (that is afterall where the code and HTML templates reside), any new additions to the contents of the container will be lost on a container restart.

## One solution
It is often not desirable to make larges changes to the code base of an existing application to accomodate this. The simplest method is to *mount* some more permanent storage into the container and to make sure the application writes to this.


