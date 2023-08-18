from django.contrib.auth.models import User
from github_profiles.models import Repository
from django.http.response import HttpResponse
from django.shortcuts import render, redirect
from github_profiles.forms import SignupForm
from django.contrib.auth import logout
import requests, json, datetime

# Create your views here.

def login_redirect(request):
    return redirect('/accounts/login')

def log_out(request):
    logout(request)
    return login_redirect(request)

def signup(request):
    if request.method == 'POST':
        form = SignupForm(request.POST)

        if form.is_valid:
            form.save()
            return redirect('/accounts/login')
    else:
        form = SignupForm()
        args = {'form':form}

        return render(request,'accounts/signup.html',args)

def profile(request,id):
    
    if not request.user.is_authenticated:
        return login_redirect(request)

    can_update = 0

    if id == str(request.user.id): 
        can_update = 1    

    if id == '0':
        id = request.user.id
        can_update = 1
    
    try:
        user = User.objects.get(id=id)
        args = {'user': user, 'repos':user.profile.repository_set.all(),'can_update':can_update}
        return render(request,'accounts/profile.html',args)
    except:
        return HttpResponse('No such user found in the database')

def update(request):

    if not request.user.is_authenticated:
        return login_redirect(request)

    try:
        response = requests.get(f'https://api.github.com/users/{request.user.username}')        
        followers = json.loads(response.text)['followers']

        request.user.profile.no_of_followers = followers
        request.user.profile.last_update = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")

        request.user.save()

        request.user.profile.repository_set.all().delete()

        response = requests.get(f'https://api.github.com/users/{request.user.username}/repos')
        data = json.loads(response.text)

        for repo in data:
            Repository.objects.create(name=repo['name'],stars=repo['stargazers_count'],profile=request.user.profile)
        
        request.user.profile.save()

        return redirect('/accounts/profile/0')
    except:
        return HttpResponse('Sorry, something went wrong while fetching user details.')

def explore(request):

    if not request.user.is_authenticated:
        return login_redirect(request)

    args = {'users':User.objects.values()}

    return render(request,'accounts/explore.html',args)