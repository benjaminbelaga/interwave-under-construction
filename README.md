# Interwave - Under Construction Page

## 📋 Overview
Page de maintenance élégante et minimaliste pour Interwave pendant la reconstruction du site web.

## 🎨 Features
- **Design minimaliste** avec gradient moderne
- **Responsive design** optimisé mobile/desktop
- **Animations CSS** subtiles et professionnelles
- **Loading progress bar** animée
- **Particules interactives** au survol souris
- **Typography moderne** avec Google Fonts (Inter)
- **Performance optimisée** - CSS/JS intégrés
- **SEO ready** avec meta tags appropriés

## 🚀 Déploiement

### Option 1: Déploiement direct
1. Copier le fichier `index.html` à la racine du serveur web
2. Configurer le serveur pour servir cette page par défaut

### Option 2: Upload via FTP/SFTP
```bash
# Via SCP (exemple)
scp index.html user@server:/var/www/html/

# Via rsync
rsync -av index.html user@server:/var/www/html/
```

### Option 3: Cloudflare Pages / Netlify / Vercel
1. Créer nouveau projet
2. Upload du fichier `index.html`
3. Deploy automatique

## 🛠 Customisation

### Modifier le logo
Remplacer le placeholder "IW" dans la div `.logo`:
```html
<!-- Remplacer ceci -->
<div class="logo-text">IW</div>

<!-- Par ceci pour une image -->
<img src="logo-interwave.png" alt="Interwave" style="max-width: 80px;">
```

### Changer les couleurs
Modifier le gradient dans le CSS:
```css
background: linear-gradient(135deg, #YOUR_COLOR_1 0%, #YOUR_COLOR_2 100%);
```

### Modifier le texte
Éditer directement dans le HTML:
- Titre principal: `<h1>Under Construction</h1>`
- Sous-titre: `<p class="subtitle">...</p>`
- Contact: `<a href="mailto:...">...</a>`

### Ajuster la progress bar
Modifier le pourcentage dans l'animation CSS:
```css
@keyframes progressFill {
    from { width: 0%; }
    to { width: 85%; } /* Changer ici */
}
```

## 📱 Responsive Breakpoints
- **Desktop**: > 768px - Design complet
- **Tablet**: 481px - 768px - Tailles ajustées
- **Mobile**: ≤ 480px - Layout optimisé mobile

## ⚡ Performance
- **CSS intégré**: Pas de requêtes externes (sauf Google Fonts)
- **JavaScript minimal**: Interactions légères
- **Animations CSS**: Hardware accelerated
- **Taille totale**: ~8KB (sans fonts)

## 🔧 Technical Stack
- **HTML5** semantic
- **CSS3** avec animations modernes
- **Vanilla JavaScript** pour interactions
- **Google Fonts** (Inter) pour typography
- **No dependencies** - Fonctionne partout

## 📊 Browser Support
- Chrome 60+
- Firefox 55+
- Safari 12+
- Edge 79+
- Mobile browsers (iOS Safari, Chrome Mobile)

## 🎯 SEO Optimizations
- Meta description appropriée
- Title tag optimisé
- Viewport meta tag pour mobile
- Semantic HTML structure
- Alt tags pour accessibilité

## 🚨 Notes importantes
1. **Remplacer l'email** `contact@interwave.com` par l'email réel
2. **Tester sur mobile** avant déploiement
3. **Backup** de l'ancien site avant remplacement
4. **Monitoring** pour s'assurer que la page se charge correctement

## 📧 Contact Support
Pour modifications ou support technique, contacter l'équipe de développement.

---
*Créé avec attention aux détails pour Interwave*