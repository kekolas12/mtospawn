<template>
    <Transition>
        <div v-show="ShowMenu">
            <div class="z-[500] absolute bottom-0 w-full justify-between">
                <!-- <img :src="Images.server_logo" alt="Server Logo" class="absolute bottom-16 left-16 h-12"> -->
                <div class="absolute bottom-16 right-16 w-72 inline-grid gap-2">
                    <button @click="SelectLocation" class="py-6 text-2xl text-white font-medium bg-[#1a1c1e] rounded-lg transition hover:bg-[#282a2c] disabled:text-white/80 disabled:bg-[#282a2c]" :disabled="GetSelectButtonDisabled">Başla</button>
                    <button @click="GoBack" class="py-1.5 text-white bg-[#1a1c1e] rounded-lg transition hover:bg-[#282a2c]">Geri Dön</button>
                </div>
            </div>
            <div id="map" class="h-screen w-full"></div>
        </div>
    </Transition>
</template>
  
<script>
    import { isEnvBrowser, createNuiEventListener, sendPost } from '@/utils.js'
    import L from 'leaflet';
    import 'leaflet/dist/leaflet.css';
    
    export default {
        data() {
            return {
                Map: null,
                ShowMenu: true,
                SelectedLocation: null,
                Markers: [],
                Images: {
                    server_logo: 'https://cdn.dont-ping.me/api/🤙👐🤓🤯🖖.png',
                    markers: {
                        default: 'https://cdn.dont-ping.me/api/🤖🤯🤓🖖🦕.png',
                        last_location: 'https://cdn.dont-ping.me/api/🙃🦕🤘🙃😊.png'
                    }    
                }
            }
        },
        computed: {
            GetSelectButtonDisabled() {
                return this.SelectedLocation ? false : true;
            }
        },
        methods: {
            OpenMenu(data) {
                this.Images = data.images;
                data.locations.map(element => {
                    this.Markers[this.Markers.length] = L.marker([element.coords.y, element.coords.x], {
                        icon: L.divIcon({
                            iconAnchor: [15, 35], 
                            popupAnchor: [-10, -27],
                            className: 'bg-transparent',
                            html: `<img src="${this.Images.markers[element.type]}" alt="Marker Icon" class="h-9">`,
                        })
                    })
                        .bindTooltip(element.label, {direction: 'bottom'})
                        .addTo(this.Map)
                        .on('click', () => {
                            this.SelectedLocation = element;
                        });
                });
                this.ShowMenu = true;
            },
            SelectLocation() {
                sendPost('SelectLocation', this.SelectedLocation)
                this.ShowMenu = false;
                this.SelectedLocation = null;
                this.Markers.map((element, index) => {
                    this.Map.removeLayer(this.Markers[index])
                });
            },
            GoBack() {
                sendPost('GoBack')
                this.ShowMenu = false;
                this.SelectedLocation = null;
                this.Markers.map((element, index) => {
                    this.Map.removeLayer(this.Markers[index])
                });
            }
        },
        mounted() {
            this.Map = L.map('map', {
                crs: L.extend({}, L.CRS.Simple, {
                    projection: L.Projection.LonLat,
                    scale: function(zoom) {
                        return Math.pow(2, zoom);
                    },
                    zoom: function(sc) {
                        return Math.log(sc) / 0.6931471805599453;
                    },
                    distance: function(pos1, pos2) {
                        var x_difference = pos2.lng - pos1.lng;
                        var y_difference = pos2.lat - pos1.lat;
                        return Math.sqrt(x_difference * x_difference + y_difference * y_difference);
                    },
                    transformation: new L.Transformation(0.02072, 117.3, -0.0205, 172.8),
                    infinite: true
                }),
                preferCanvas: true,
                layers: L.tileLayer('https://nanoproject-s.github.io/mapstyle_satellite/{z}/{x}/{y}.jpg', {
                    minZoom: 2,
                    maxZoom: 5
                }),
                center: [0, 0],
                zoom: 3,
                maxBounds: [
                    [8425, 6690],
                    [-4060, -5660]
                ],
            });

            this.ShowMenu = false;

            createNuiEventListener(event => this[event.data.action](event.data.array));
        }
    }
</script>
  
<style>
    body {
        font-family: 'Inter', sans-serif;
    }

    .v-enter-active,
    .v-leave-active {
        transition: opacity 0.5s ease;
    }

    .v-enter-from,
    .v-leave-to {
        opacity: 0;
    }

    .leaflet-top {
        margin-top: 1rem;
    }

    .leaflet-left {
        margin-left: 1rem;
    }

    .leaflet-bar a {
        background-color: #181d1e;
        color: #929799;
        border-color: transparent;
    }

    .leaflet-bar a:hover {
        background-color: rgb(51, 55, 56);
    }
</style>