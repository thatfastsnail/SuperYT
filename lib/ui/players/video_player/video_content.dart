import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_fade/image_fade.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:newpipeextractor_dart/models/infoItems/video.dart';
import 'package:newpipeextractor_dart/models/videoInfo.dart';
import 'package:share_plus/share_plus.dart';
import 'package:songtube/internal/models/content_wrapper.dart';
import 'package:songtube/main.dart';
import 'package:songtube/ui/components/custom_inkwell.dart';
import 'package:songtube/ui/components/shimmer_container.dart';
import 'package:songtube/ui/components/text_icon_button.dart';
import 'package:songtube/ui/players/video_player/comments.dart';
import 'package:songtube/ui/players/video_player/suggestions.dart';
import 'package:songtube/ui/menus/download_content_menu.dart';
import 'package:songtube/ui/text_styles.dart';

class VideoPlayerContent extends StatelessWidget {
  const VideoPlayerContent({
    required this.content,
    super.key});
  final ContentWrapper content;
  @override
  Widget build(BuildContext context) {
    VideoInfo? videoInfo = content.videoDetails?.videoInfo;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        // Video Title and Show More Button
        SliverToBoxAdapter(
          child: Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Text(content.infoItem.name ?? 'Unknown', style: bigTextStyle(context).copyWith(fontSize: 20), maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
              IconButton(
                onPressed: () {
                  // TODO SHOW VIDEO DETAILS
                },
                icon: Icon(Icons.expand_more, color: Theme.of(context).primaryColor)
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        // Action Buttons (Like, dislike, download, etc...)
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Like Button
              TextIconButton(
                icon: const Icon(LineIcons.thumbsUp),
                text: videoInfo != null && (videoInfo.likeCount != -1 && videoInfo.likeCount != null)
                  ? NumberFormat.compact().format(videoInfo.likeCount) : 'Like',
                onTap: () {
            
                },
              ),
              // Dislike Button
              TextIconButton(
                icon: const Icon(LineIcons.thumbsDown),
                text: videoInfo != null && videoInfo.dislikeCount != -1
                  ? NumberFormat.compact().format(videoInfo.dislikeCount) : 'Dislike',
                onTap: () {
            
                },
              ),
              // Like Button
              TextIconButton(
                icon: const Icon(LineIcons.share),
                text: 'Share',
                onTap: () {
                  Share.share(content.infoItem.url);
                },
              ),
              // Like Button
              TextIconButton(
                icon: const Icon(Ionicons.add_outline),
                text: 'Playlist',
                onTap: () {
            
                },
              ),
              // Like Button
              TextIconButton(
                icon: const Icon(LineIcons.download),
                text: 'Download',
                onTap: () {
                  showModalBottomSheet(
                    context: internalNavigatorKey.currentContext!,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => DownloadContentMenu(content: content));
                },
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 6)),
        SliverToBoxAdapter(child: Divider(color: Theme.of(context).dividerColor.withOpacity(0.1), indent: 12, endIndent: 12)),
        const SliverToBoxAdapter(child: SizedBox(height: 6)),
        // Channel Details
        SliverToBoxAdapter(
          child: CustomInkWell(
            onTap: () {
            
            },
            child: Row(
              children: [
                const SizedBox(width: 12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: videoInfo != null
                    ? SizedBox(
                        height: 50,
                        width: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: ImageFade(
                            fadeDuration: const Duration(milliseconds: 300),
                            placeholder: ShimmerContainer(height: 40, width: 40, borderRadius: BorderRadius.circular(100)),
                            image: NetworkImage(videoInfo.uploaderAvatarUrl!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : ShimmerContainer(height: 50, width: 50, borderRadius: BorderRadius.circular(100)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.infoItem.uploaderName ?? 'Unknown',
                        style: subtitleTextStyle(context).copyWith(fontWeight: FontWeight.w900),
                      ),
                      Text('SUBSCRIBE',
                        style: smallTextStyle(context).copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w900, letterSpacing: 1),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {
          
                  },
                  icon: const Icon(Icons.expand_more)
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 6)),
        SliverToBoxAdapter(child: Divider(color: Theme.of(context).dividerColor.withOpacity(0.1), indent: 12, endIndent: 12)),
        // Comments Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: VideoPlayerComments(url: content.infoItem.url),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 6)),
        // Video Suggestions
        VideoPlayerSuggestions(url: content.infoItem.url)
      ],
    );
  }
}