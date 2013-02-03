Openspending Installer
=====================

An installer for the [OpenSpending](http://openspending.org) Backend 

You will need a Postrgres Database up and running, as well as RabbitMQ.

Download solr from :http://www.apache.org/dist/lucene/solr/4.1.0/ and
unpack it to a directory.

Your user needs to be able to create databases in postgres. You can achieve
this with 

  sql# ALTER ROLE username WITH CREATEDB; 

if you don't already have things set up this way.
```
   run bash install 
```

commandline opts:
  --git-repo The Repo to clone from (default: the official openspending)
  --js-repo the openspendingjs repository to clone from (default: as above)
  --target-dir the directory to install to (default: openspending)
  --db-user your db user (optional)
  --db-name the name of the database to be created (default: openspending)
  --virtualenv your virtualenv command (default: virtualenv
  --solr-dir the directory you extracted solr to

