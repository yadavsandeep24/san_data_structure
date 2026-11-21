// How image loaders work (conceptually)
// Source: book/part-v/18-caching-strategies.md
package ch18.how_image_loaders_work

class App : Application(), SingletonImageLoader.Factory {
    override fun newImageLoader(context: PlatformContext): ImageLoader =
        ImageLoader.Builder(context)
            .memoryCache {
                MemoryCache.Builder()
                    .maxSizePercent(context, 0.20) // bounded, size-weighted LRU
                    .build()
            }
            .crossfade(true)
            .build()
}

override fun onBindViewHolder(holder: RowHolder, position: Int) {
    val item = getItem(position)
    Glide.with(holder.itemView)               // lifecycle from the hosting Fragment/Activity
        .load(item.thumbUrl)
        .override(thumbPx)                    // size-aware key: decode at 48dp, not 4000px
        .centerCrop()
        .into(holder.binding.thumb)           // cancels whatever this ImageView loaded before
}

override fun onViewRecycled(holder: RowHolder) {
    Glide.with(holder.itemView).clear(holder.binding.thumb) // free the bitmap for reuse
}

@Composable
fun Thumb(url: String) {
    AsyncImage(
        model = url,
        contentDescription = null,
        contentScale = ContentScale.Crop,
        modifier = Modifier.size(48.dp),      // bounded constraints → 48dp decode, size-aware key
    )
}
