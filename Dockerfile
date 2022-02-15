FROM node:10 as build-stage

WORKDIR /workspace/
COPY ./client /workspace/client

RUN npm install -g @vue/cli@3.3.0
RUN npm install -g @vue/cli-service@3.3.0

COPY ./client/package* /workspace/

RUN npm install
ENV NODE_PATH=/workspace/node_modules

WORKDIR /workspace/client
RUN npm run build

FROM jsbroks/coco-annotator:python-env

WORKDIR /workspace/
COPY ./backend/ /workspace/
# when using coco-annotation as a git subtree, there is no .git folder
# in this subrepo; unclear what the .git will do, so let's see if we can do without it.
# COPY ./.git /workspace/.

RUN python set_path.py

COPY --from=build-stage /workspace/client/dist /workspace/dist

ENV FLASK_ENV=production
ENV DEBUG=false

EXPOSE 5000
CMD gunicorn -c webserver/gunicorn_config.py webserver:app --no-sendfile --timeout 180
