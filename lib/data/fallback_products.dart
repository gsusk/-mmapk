import '../models/product.dart';

final fallbackProducts = [
  const Product(
    id: 1,
    name: 'Audifonos Inalambricos Premium',
    category: 'Audio',
    price: 349900,
    image: 'assets/images/headphones.jpg',
    description:
        'Cancelacion de sonido premium para una experiencia de audio definitiva.',
    brand: 'MMARK',
    stock: 12,
  ),
  const Product(
    id: 2,
    name: 'Refrigerador LG Smart Door',
    category: 'Electrodomesticos',
    price: 2499900,
    image: 'assets/images/LG_REF_GR-H812HLHM_9.webp',
    description: 'Refrigerador inteligente con tecnologia puerta a puerta.',
    brand: 'LG',
    stock: 4,
  ),
  const Product(
    id: 3,
    name: 'PC Gamer Power L38 Ryzen 7',
    category: 'Computadores',
    price: 3199900,
    image:
        'assets/images/computador-pc-torre-gamer-power-l38-amd-ryzen-7-5700g-ssd-128-hdd-1tb-ram-16gb-led-22-pulgadas.webp',
    description: 'Equipo gamer con Ryzen 7, SSD y memoria de alto rendimiento.',
    brand: 'Power',
    stock: 7,
  ),
];
