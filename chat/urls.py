from django.urls import path

from chat import views

urlpatterns = [
    path('', views.index, name='index'),
    path('signin/', views.signin, name='signin'),
    path('signup/', views.signup, name='signup'),
    path('signout/', views.signout, name='signout'),
    path('getUser/', views.isLoggedIn, name='isLoggedIn'),
    path('<str:room_name>/', views.room, name='room'),
]