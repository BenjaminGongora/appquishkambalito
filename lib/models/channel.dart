class Channel {
  final String id;
  final String name;
  final String streamUrl;
  final String type; // 'audio' or 'video'
  final String? imageUrl;
  final String category; // 'radio' or 'tv'

  Channel({
    required this.id,
    required this.name,
    required this.streamUrl,
    required this.type,
    required this.category,
    this.imageUrl,
  });
}

// Lista de canales disponibles
List<Channel> radioChannels = [
  Channel(
    id: 'radio',
    name: 'Radio Quishkambalito',
    streamUrl: 'https://servidor26.brlogic.com:7652/live',
    type: 'audio',
    category: 'radio',
    imageUrl: 'https://example.com/images/radio.jpg', // Reemplaza con URL real
  ),
];

List<Channel> tvChannels = [
  Channel(
    id: 'rqtv',
    name: 'Canal Principal (rqtv)',
    streamUrl: 'https://quishkambalito.com/hls/rqtv.m3u8',
    type: 'video',
    category: 'tv',
    imageUrl: 'https://example.com/images/rqtv.jpg',
  ),
  Channel(
    id: 'rqtv2',
    name: 'Canal Secundario (rqtv2)',
    streamUrl: 'https://quishkambalito.com/hls/rqtv2.m3u8',
    type: 'video',
    category: 'tv',
    imageUrl: 'https://example.com/images/rqtv2.jpg',
  ),
  Channel(
    id: 'evento1',
    name: 'Evento en Vivo (evento1)',
    streamUrl: 'https://quishkambalito.com/hls/evento1.m3u8',
    type: 'video',
    category: 'tv',
    imageUrl: 'https://example.com/images/evento1.jpg',
  ),
];