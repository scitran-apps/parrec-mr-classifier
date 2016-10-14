# scitran-apps/parrec-mr-classifier
#
# Use nibabel to classify raw PARREC data from Philips.
#
# Example usage:
#   docker run --rm -ti \
#        -v /path/to/dicom/data:/data \
#        scitran-apps/parrec-mr-classifier \
#        /data/input.zip \
#        /data/outprefix
#

FROM ubuntu:trusty

MAINTAINER Michael Perry <lmperry@stanford.edu>

# Install dependencies
RUN apt-get update && apt-get -y install \
    python \
    python-numpy \
    python-nibabel

# Make directory for flywheel spec (v0)
ENV FLYWHEEL /flywheel/v0
RUN mkdir -p ${FLYWHEEL}
COPY run ${FLYWHEEL}/run
COPY manifest.json ${FLYWHEEL}/manifest.json

# Add code to determine measurement from acquisition label
ADD https://raw.githubusercontent.com/scitran/utilities/0deeda8e123f27545c9291f1f9d7c4d0a89c8e2f/measurement_from_label.py ${FLYWHEEL}/measurement_from_label.py

# Copy classifier code into place
COPY parrec-mr-classifier.py ${FLYWHEEL}/parrec-mr-classifier.py

# Set the entrypoint
ENTRYPOINT ["/flywheel/v0/run"]