#!/usr/bin/env python

import time
from locust import HttpUser, task, between

class QuickstartUser(HttpUser):
    wait_time = between(1, 2.5)

    @task
    def root(self):
        self.client.get("/")

    @task
    def dependencies(self):
        self.client.get("/dependencies")

    @task
    def minimumSecure(self):
        self.client.get("/minimumSecure")

    @task
    def latestReleases(self):
        self.client.get("/latestReleases")

    @task
    def minimum_secure(self):
        self.client.get("/api/minimum-secure")

    @task
    def latest_releases(self):
        self.client.get("/api/latest-releases")
