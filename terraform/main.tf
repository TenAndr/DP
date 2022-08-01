terraform {
  required_version = "= 1.2.5"
 
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.73"
    }
  }
}
provider "yandex" {
  token     = "AQAAAABcPnfmAATuwfAbav-aa03Eo2z95VkEmYE"
  cloud_id  = "b1gc5g05modjqt1t77f6"
  folder_id = "b1gc5g05modjqt1t77f6"
  zone      = "ru-central1-a"
}
