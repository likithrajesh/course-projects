from django.contrib import admin
from github_profiles.models import Profile, Repository

# Register your models here.

admin.site.register(Profile)
admin.site.register(Repository)
