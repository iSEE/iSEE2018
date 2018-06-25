FROM csoneson/isee:master

MAINTAINER kevin.rue-albrecht@kennedy.ox.ac.uk
LABEL authors="kevin.rue-albrecht@kennedy.ox.ac.uk" \
    description="Docker image containing the iSEE package and data from Bodenmiller et al., (2012)."

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Make port 1234 available to the world outside this container
EXPOSE 1234

# Run the script that launches the Shiny app
CMD Rscript docker.R
