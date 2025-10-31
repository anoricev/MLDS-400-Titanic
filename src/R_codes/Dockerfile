FROM rocker/r-ver:4.4.1
WORKDIR /app

COPY src/R_codes/install_packages.R /app/install_packages.R
RUN Rscript install_packages.R

COPY src/R_codes/main.R /app/main.R
RUN mkdir -p /app/output

CMD ["Rscript", "main.R"]

