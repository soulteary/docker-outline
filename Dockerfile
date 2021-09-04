# syntax=docker/dockerfile:1.2

# This file is modified from the outline official repository
# https://github.com/outline/outline/blob/main/Dockerfile
# Used to build services that support Generic OAuth Authorization https://github.com/outline/outline/commit/47953b3354da144439aced94270ca6a88ea56399
# And will be deprecated after the official launch of the new version

FROM node:14-alpine AS builder
RUN apk add git
WORKDIR /opt

ENV OUTLINE_SOURCE=https://github.com/outline/outline.git
ENV OUTLINE_HASH=47953b3354da144439aced94270ca6a88ea56399
RUN git clone ${OUTLINE_SOURCE} --depth=10
WORKDIR /opt/outline
RUN git checkout ${OUTLINE_HASH}
RUN yarn install
RUN yarn build



FROM node:14-alpine AS runner
WORKDIR /opt/outline
ENV NODE_ENV production

COPY --from=builder /opt/outline/build ./build
COPY --from=builder /opt/outline/server ./server
COPY --from=builder /opt/outline/public ./public
COPY --from=builder /opt/outline/.sequelizerc ./.sequelizerc
COPY --from=builder /opt/outline/node_modules ./node_modules
COPY --from=builder /opt/outline/package.json ./package.json

RUN addgroup -g 1001 -S nodejs && \
  adduser -S nodejs -u 1001 && \
  chown -R nodejs:nodejs /opt/outline/build

USER nodejs

EXPOSE 3000
CMD ["yarn", "start"]