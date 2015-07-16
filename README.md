# Jenkins

This Jenkins can be run in a container of a host by mounting the docker.sock


## Included PHP tools

- phpunit from <https://phar.phpunit.de/phpunit.phar>
- composer from <https://getcomposer.org/composer.phar>
- phpmd from <http://static.phpmd.org/php/latest/phpmd.phar>
- sami from <http://get.sensiolabs.org/sami.phar>
- phpcov from <https://phar.phpunit.de/phpcov.phar>
- phpcpd from <https://phar.phpunit.de/phpcpd.phar>
- phploc from <https://phar.phpunit.de/phploc.phar>
- phptok from <https://phar.phpunit.de/phptok.phar>
- box from <https://github.com/box-project/box2/releases/download/2.5.2/box-2.5.2.phar>
- phpbrew from <https://github.com/phpbrew/phpbrew/raw/master/phpbrew>


## Included Plugins

- checkstyle
- cloverphp
- crap4j
- dry
- email-ext
- git-client
- git
- github-api
- github
- greenballs
- htmlpublisher
- jdepend
- plot
- pmd
- postbuild-task
- postbuildscript
- scm-api
- slack
- violations
- warnings
- xunit

## Build Image

plugins.txt list the plugins you want to installed in Jenkins.

```
docker build -t myjenkins .
```

## Run Image

```
docker run -d -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker -v /home/ubuntu/jenkins_home:/var/jenkins_home -p 8080:8080 myjenkins
```

or 

```
docker run -d -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker -v /home/ubuntu/jenkins_home:/var/jenkins_home -v /home/ubuntu/work:/work -p 8080:8080 --name jenkins myjenkins
```

## Jenkins Job Configuration

- On the configuration page, click “Add build step” then “Execute shell”.

```
sudo docker run [Docker Image]
```

- Console Output will show the result.

## Github and Jenkins

Install Github API plugin and Github plugin.    
Reference: plugins.txt

### Github webhook

- Githup repo > Settings > Webhooks & Services > Services > Add service   
- choose Jenkins (GitHub plugin)   
- Jenkins hook url: `http://<you jenkins url>:8080/github-webhook/`
  
### Jenkins Job Configuration 
- source code management > git
	- input Repository URL
	- Additional Behaviours	> Check out to a sub-directory    
	  for example: `$BUILD_NUMBER`   
	  Jenkins will clone source code into $BuildId_NUMBER folder.
- check Build when a change is pushed to GitHub
- Add build step > Execute shell   
  for example: Mount $BUILD_NUMBER to docker container.
  
  ```
  sudo docker run -v /home/ubuntu/jenkins_home/workspace/docker-test/$BUILD_NUMBER:/test test
  ```

## Issue
- Security: Jenkins user has root access to the host
