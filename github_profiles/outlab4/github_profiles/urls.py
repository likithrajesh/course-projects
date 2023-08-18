from outlab4.views import login_redirect
from django.conf.urls import url
from github_profiles import views
from django.contrib.auth.views import LoginView

urlpatterns = [
    url(r'^$',views.login_redirect),
    url(r'^login/$',LoginView.as_view(template_name='accounts/login.html'),name='login'),
    url(r'^logout/$',views.log_out,name='logout'),
    url(r'^signup/$',views.signup,name='signup'),
    url(r'^profile/(?P<id>[0-9]*)/$',views.profile,name='profile'),
    url(r'^update/$',views.update,name='update'),
    url(r'^explore/$',views.explore, name='explore')
]