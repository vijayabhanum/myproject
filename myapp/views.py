from django.shortcuts import render
from .models import NameModel
# Create your views here.

def homeview(request):

    all_names = NameModel.objects.all()

    context = {
        'names' : all_names,
    }

    return render(request, 'index.html', context)