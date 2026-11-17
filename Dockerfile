FROM python:3.12-slim
RUN useradd -m -u 1000 user
WORKDIR /app
# The repo holds only this Dockerfile and the project ZIP; the build unpacks it.
COPY *.zip /tmp/pkg/
RUN python -c "import glob, zipfile; [zipfile.ZipFile(z).extractall('/app') for z in sorted(glob.glob('/tmp/pkg/*.zip'))]" \
 && test -f /app/railora/backend/api.py \
 && chown -R user:user /app
USER user
WORKDIR /app/railora
# No secrets here. RAILCORE_API_KEY and RAILORA_ACCESS_CODE are set in the Render dashboard.
ENV HOST=0.0.0.0 PORT=10000 RAILORA_MODE=production ROUTES_MODE=off PROVIDER_MAX_CALLS_PER_SEARCH=25 PYTHONUNBUFFERED=1
EXPOSE 10000
CMD ["python", "backend/api.py"]
