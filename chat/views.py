from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth import get_user_model, authenticate, login, logout
from django.db.utils import IntegrityError
from django.http import JsonResponse

# Create your views here.
def index(request):
    return render(request, 'web/index.html', {})

@csrf_exempt
def signup(request):
    User = get_user_model()
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        # print(username, password)
        try:
            user = User.objects.create(username=username)
            user.set_password(password)
            user.save()
            return JsonResponse(status=200, data={
                'msg': 'User created Successfully.'
            })
        except IntegrityError:
            return JsonResponse(status='400', data={
                'msg': 'User already Exists.'
            })
    
    return JsonResponse(status='400', data={
        'msg': 'Invalid Request'
    })

@csrf_exempt
def signin(request):
    User = get_user_model()
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']

        user = authenticate(username=username, password=password)

        if user is not None:
            login(request, user)
            response = JsonResponse(status=200, data={
                'msg': 'Successfully Logged In',
                'username': username,
            })
            return response 
        else:
            return JsonResponse(status=400, data={
                'msg': 'Invalid Username or Password'
            })
    
    return JsonResponse(status=400, data={
        'msg': 'Invalid Method'
    })

def signout(request):
    if request.user.is_authenticated:
        logout(request)

        return JsonResponse(status=200, data={
            'msg': 'Successfully Logged out.'
        })
    
    return JsonResponse(status=400, data={
        'msg': 'Please Login First.'
    })

def isLoggedIn(request):
    if request.user.is_authenticated:
        return JsonResponse(status=200, data={
            'msg': 'Already logged in.',
            'username': request.user.username,
        })
    return JsonResponse(status=400, data={
        'msg': 'Please Login First.'
    })

def room(request, room_name):
    return render(request, 'chatroom.html', {
        'room_name': room_name
    })
