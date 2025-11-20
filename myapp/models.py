from django.db import models

# Create your models here.

class NameModel(models.Model):
    full_name = models.CharField(max_length=20)
    age = models.IntegerField()
    place = models.CharField(max_length=10)

    def __str__(self):
        return self.full_name
