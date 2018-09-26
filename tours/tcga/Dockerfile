FROM csoneson/isee:master

MAINTAINER kevin.rue-albrecht@kennedy.ox.ac.uk
LABEL authors="kevin.rue-albrecht@kennedy.ox.ac.uk" \
    description="Docker image containing the iSEE package and data from Rahman et al., (2015)."

ENV rootdir /app

# Set the working directory to /app
WORKDIR $rootdir

# Copy the current directory contents into the container at /app
ADD sce.rds $rootdir
ADD sce.hdf5 $rootdir
ADD tour.txt $rootdir
ADD docker.R $rootdir
ADD app.R $rootdir

# Make port 1234 available to the world outside this container
EXPOSE 1234

# Run the script that launches the Shiny app
CMD Rscript docker.R
