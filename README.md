# Example of a Dockerized shiny app

In this repo you can find an example of a Dockerized shiny application utilizing the following concepts:
- [renv](https://rstudio.github.io/renv/articles/renv.html) packages installation (enhanced by [pak](https://pak.r-lib.org/))
- testing the app during the build
- rootless container mode (required by most modern infrastructures)

## Build

Default build:
```
docker build -t shiny-docker .
```

Build in case you need to specify git read token (see this [vignette](https://cran.r-project.org/web/packages/renv/vignettes/package-install.html))
```
docker build -t shiny-docker --build-arg GIT_READ_TOKEN=my_token .
```

## Run 

Default run:
```
docker run -it --rm -p 3838:3838 shiny-docker
```

Change env vars for the run:
```
docker run -it --rm -p 3838:3838 -e DB_HOST=localhost -e DB_USER=user -e DB_PASS=password shiny-docker
```

## Local run

The app requires some env variables to run (just for demonstration purposes). The easiest way to provide the variables is to create `.Renviron` file in your home directory:
```
DB_HOST=localhost
DB_USER=user
DB_PASSWORD=password
```
You need to restart your R session in order to load the variables from the file.
