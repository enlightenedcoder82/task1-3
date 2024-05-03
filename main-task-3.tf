terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.27.0"
    }
  }
}

provider "google" {
  # Configuration options
  project     = "project-armaggaden-may11"
  region      = "eu-west1"
  zone        = "eu-west1-b"
  credentials = "project-armaggaden-may11-2cff6047c441.json"
}

resource "google_compute_network" "network" {
  name                  = "vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "vpn-subnetwork"
  ip_cidr_range = "10.0.1.0./16"
    region        = "europe-west1"
  network       = google_compute_network.network.self_link
}

resource "google_compute_vpn_gateway" "vpn_gateway" {
 name = "vpn-gateway"
  network = google_compute_network.network.self_link
}

resource "google_compute_vpn_tunnel" "vpn_tunnel" {
  name = "vpn-tunnel"
  peer_ip = "15.0.0.2"
  shared_secret = "mysecret"
  

target_vpn_gateway = google_compute_vpn_gateway.vpn_gateway.self_link
ike_version = 2
local_traffic_selector = ["10.0.0.0/16"]
remote_traffic_selector = ["15.0.0.0/16"]

}