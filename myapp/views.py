from django.shortcuts import render
from django.http import HttpResponse
# Create your views here.


def home(request):
    
    context = {
        'title' : 'Welcome to My Project',
        'message': 'Django + Docker + PostgresSQL is working!'
    }
    
    return render(request, 'home.html', context)

def health_check(request):
    return HttpResponse('OK', content_types='text/plain')