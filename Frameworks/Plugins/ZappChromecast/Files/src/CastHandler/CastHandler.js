import * as React from "react";
import { View, ActivityIndicator } from "react-native";
import { useNavigation } from "@applicaster/zapp-react-native-utils/reactHooks/navigation";
import { imageSrcFromMediaItem } from "@applicaster/zapp-react-native-utils/cellUtils";

type Item = {
  id: string | number,
  [string]: any,
};

type Props = {
  entry: Item,
  plugin: {},
  feedId: ?string,
  feedTitle: ?string,
};

export function CastHandler(props: Props) {
  const entry = props?.entry;
  const Cast = props?.plugin;
  const navigator = useNavigation();

  const poster = imageSrcFromMediaItem(entry, ["chromecast_poster"]);
  const image = imageSrcFromMediaItem(entry, ["image_base"]);
  const media = {
    title: entry?.title,
    subtitle: entry?.summary,
    studio: entry?.author?.name,
    duration: entry?.extensions?.duration,
    mediaUrl: entry?.content?.src,
    imageUrl: image,
    posterUrl: poster,
  };

  // TODO: retreive feed data
  const analytics = {
    feedId: props?.feedId,
    feedTitle: props?.feedTitle,
    entryId: entry?.id,
    itemName: entry?.title,
    vodType: entry?.content?.type,
    free: entry?.extensions?.free,
  };

  const loadingStyle = {
    flex: 1,
    backgroundColor: "transparent",
  };

  React.useEffect(() => {
    Cast.castMedia({ ...media, analytics }).then((e) => {
      Cast.launchExpandedControls();
      navigator.goBack();
    });
  }, []);

  return (
    <View style={loadingStyle}>
      <ActivityIndicator style={loadingStyle} size="large" color="#aaa" />
    </View>
  );
}
