//
//  Tweets.swift
//  PregBuddyTweets
//
//  Created by Amit Majumdar on 07/03/18.
//  Copyright © 2018 Amit Majumdar. All rights reserved.
//


import Foundation

struct Tweet {
    
    var created_at : String? = ""
    var retweet_count: String? = ""
    var text: String? = ""
    var hashTag: String? = ""
    var name: String? = ""
    var profile_image_url: String? = ""
    var media_url: String? = ""
    var screen_name: String? = ""
}


class Tweets: NSObject {
    
    class func parseTweets(_ tweetsResponse : [String : Any]) -> [Tweet] {
        
        var tweetsArray = [Tweet]()
        
        let statuses = tweetsResponse["statuses"] as! [[String: Any]]
        
        for tweets in statuses {
            
            let created_at = String.checkIfStringIsNull(forItem: tweets, key: "created_at")
            let retweet_count = NSNumber.checkIfNumberIsNull(forItem: tweets, forKey: "retweet_count")
            let entitiesPresent = Dictionary<String, Any>.ifExists(forItem: tweets, withKey: "entities")
            var media_url = " "
            var hashTag = ""
            if entitiesPresent == true{
                let entities = tweets["entities"] as? [String : Any]
                if entities != nil{
                    
                    if Dictionary<String, Any>.ifExists(forItem: entities!, withKey: "hashtags") == true{
                        hashTag = getHashtags(entities!["hashtags"] as? [[String : Any]])
                    }
                    if Dictionary<String, Any>.ifExists(forItem: entities!, withKey: "media") == true{
                        let media = entities!["media"] as? [String: Any]
                        if media != nil{
                            media_url = String.checkIfStringIsNull(forItem: media!, key: "media_url_https")
                        }
                    }
                }
            }
            let text = String.checkIfStringIsNull(forItem: tweets, key: "text")
            var name = ""
            var screen_name = ""

            var profile_image_url = ""
            
            if Dictionary<String, Any>.ifExists(forItem: tweets, withKey: "user") == true{
                let user = tweets["user"] as? [String: Any]
                if user != nil{
                    name = String.checkIfStringIsNull(forItem: user!, key: "name")
                    screen_name = String.checkIfStringIsNull(forItem: user!, key: "screen_name")

                    profile_image_url = String.checkIfStringIsNull(forItem: user!, key: "profile_background_image_url_https")
                }
            }
            let tweet = Tweet(created_at: created_at, retweet_count: "\(retweet_count)", text: text, hashTag: hashTag, name: name, profile_image_url: profile_image_url, media_url: media_url,screen_name: screen_name)
            
            tweetsArray.append(tweet)
        }
        return tweetsArray
        
    }
    
    
    
    class func getHashtags(_ hashtags : [[String : Any]]?) -> String {
        
        let mutableTag = NSMutableString()
        if hashtags != nil {
            for hashTag in hashtags! {
                let str = hashTag["text"] as! String
                mutableTag.append("#\(str) ")
            }
        }
        
        let str = "\(mutableTag)"
        return str.trimWhiteSpaces()
    }
    
}



/*

{

    statuses =     (
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Wed Mar 07 11:32:23 +0000 2018";
            entities =             {
                hashtags =                 (
                    {
                        indices =                         (
                            59,
                            67
                        );
                        text = FARTING;
                },
                    {
                        indices =                         (
                            68,
                            79
                        );
                        text = clips4sale;
                }
                );
                media =                 (
                    {
                        "display_url" = "pic.twitter.com/Bco1iDrqD6";
                        "expanded_url" = "https://twitter.com/Angiefartland/status/963817507739103233/video/1";
                        id = 963817462121803777;
                        "id_str" = 963817462121803777;
                        indices =                         (
                            92,
                            115
                        );
                        "media_url" = "http://pbs.twimg.com/ext_tw_video_thumb/963817462121803777/pu/img/CSVnKDdEyvSQplCm.jpg";
                        "media_url_https" = "https://pbs.twimg.com/ext_tw_video_thumb/963817462121803777/pu/img/CSVnKDdEyvSQplCm.jpg";
                        sizes =                         {
                            large =                             {
                                h = 720;
                                resize = fit;
                                w = 1276;
                            };
                            medium =                             {
                                h = 677;
                                resize = fit;
                                w = 1200;
                            };
                            small =                             {
                                h = 384;
                                resize = fit;
                                w = 680;
                            };
                            thumb =                             {
                                h = 150;
                                resize = crop;
                                w = 150;
                            };
                        };
                        "source_status_id" = 963817507739103233;
                        "source_status_id_str" = 963817507739103233;
                        "source_user_id" = 3091417000;
                        "source_user_id_str" = 3091417000;
                        type = photo;
                        url = "https://t.co/Bco1iDrqD6";
                    }
                );
                symbols =                 (
                );
                urls =                 (
                    {
                        "display_url" = "clips4sale.com/100839/19148437";
                        "expanded_url" = "https://clips4sale.com/100839/19148437";
                        indices =                         (
                            35,
                            58
                        );
                        url = "https://t.co/mc3ejPQoQL";
                    }
                );
                "user_mentions" =                 (
                    {
                        id = 3091417000;
                        "id_str" = 3091417000;
                        indices =                         (
                            3,
                            17
                        );
                        name = Angiefartland;
                        "screen_name" = Angiefartland;
                },
                    {
                        id = 116881078;
                        "id_str" = 116881078;
                        indices =                         (
                            80,
                            91
                        );
                        name = "Clips4Sale.com";
                        "screen_name" = clips4sale;
                }
                );
            };
            "extended_entities" =             {
                media =                 (
                    {
                        "additional_media_info" =                         {
                            monetizable = 0;
                            "source_user" =                             {
                                "contributors_enabled" = 0;
                                "created_at" = "Fri Mar 13 17:21:53 +0000 2015";
                                "default_profile" = 0;
                                "default_profile_image" = 0;
                                description = "SKYPE SESSION:  live:funwithexc4s\nCONTACT: funwithexc4s@gmail.com";
                                entities =                                 {
                                    description =                                     {
                                        urls =                                         (
                                        );
                                    };
                                    url =                                     {
                                        urls =                                         (
                                            {
                                                "display_url" = "clips4sale.com/100839";
                                                "expanded_url" = "http://clips4sale.com/100839";
                                                indices =                                                 (
                                                    0,
                                                    23
                                                );
                                                url = "https://t.co/IQf9dkpT5h";
                                            }
                                        );
                                    };
                                };
                                "favourites_count" = 291;
                                "follow_request_sent" = 0;
                                "followers_count" = 4961;
                                following = 0;
                                "friends_count" = 148;
                                "geo_enabled" = 0;
                                "has_extended_profile" = 0;
                                id = 3091417000;
                                "id_str" = 3091417000;
                                "is_translation_enabled" = 0;
                                "is_translator" = 0;
                                lang = en;
                                "listed_count" = 16;
                                location = "";
                                name = Angiefartland;
                                notifications = 0;
                                "profile_background_color" = FF6699;
                                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme11/bg.gif";
                                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme11/bg.gif";
                                "profile_background_tile" = 1;
                                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/3091417000/1520098160";
                                "profile_image_url" = "http://pbs.twimg.com/profile_images/969537734053453824/NMWDEJZN_normal.jpg";
                                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/969537734053453824/NMWDEJZN_normal.jpg";
                                "profile_link_color" = E81C4F;
                                "profile_sidebar_border_color" = 000000;
                                "profile_sidebar_fill_color" = 000000;
                                "profile_text_color" = 000000;
                                "profile_use_background_image" = 1;
                                protected = 0;
                                "screen_name" = Angiefartland;
                                "statuses_count" = 283;
                                "time_zone" = Belgrade;
                                "translator_type" = none;
                                url = "https://t.co/IQf9dkpT5h";
                                "utc_offset" = 3600;
                                verified = 0;
                            };
                        };
                        "display_url" = "pic.twitter.com/Bco1iDrqD6";
                        "expanded_url" = "https://twitter.com/Angiefartland/status/963817507739103233/video/1";
                        id = 963817462121803777;
                        "id_str" = 963817462121803777;
                        indices =                         (
                            92,
                            115
                        );
                        "media_url" = "http://pbs.twimg.com/ext_tw_video_thumb/963817462121803777/pu/img/CSVnKDdEyvSQplCm.jpg";
                        "media_url_https" = "https://pbs.twimg.com/ext_tw_video_thumb/963817462121803777/pu/img/CSVnKDdEyvSQplCm.jpg";
                        sizes =                         {
                            large =                             {
                                h = 720;
                                resize = fit;
                                w = 1276;
                            };
                            medium =                             {
                                h = 677;
                                resize = fit;
                                w = 1200;
                            };
                            small =                             {
                                h = 384;
                                resize = fit;
                                w = 680;
                            };
                            thumb =                             {
                                h = 150;
                                resize = crop;
                                w = 150;
                            };
                        };
                        "source_status_id" = 963817507739103233;
                        "source_status_id_str" = 963817507739103233;
                        "source_user_id" = 3091417000;
                        "source_user_id_str" = 3091417000;
                        type = video;
                        url = "https://t.co/Bco1iDrqD6";
                        "video_info" =                         {
                            "aspect_ratio" =                             (
                                319,
                                180
                            );
                            "duration_millis" = 7000;
                            variants =                             (
                                {
                                    bitrate = 2176000;
                                    "content_type" = "video/mp4";
                                    url = "https://video.twimg.com/ext_tw_video/963817462121803777/pu/vid/1276x720/XZr_8cFYT4NXunA_.mp4";
                            },
                                {
                                    bitrate = 832000;
                                    "content_type" = "video/mp4";
                                    url = "https://video.twimg.com/ext_tw_video/963817462121803777/pu/vid/638x360/zeOHiCJtO9f98jri.mp4";
                            },
                                {
                                    "content_type" = "application/x-mpegURL";
                                    url = "https://video.twimg.com/ext_tw_video/963817462121803777/pu/pl/-HpVeXWtMIUsrR0w.m3u8";
                            },
                                {
                                    bitrate = 256000;
                                    "content_type" = "video/mp4";
                                    url = "https://video.twimg.com/ext_tw_video/963817462121803777/pu/vid/318x180/br8mtAVcM8G6_0Fi.mp4";
                            }
                            );
                        };
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971347827048767488;
            "id_str" = 971347827048767488;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "possibly_sensitive" = 1;
            "retweet_count" = 48;
            retweeted = 0;
            "retweeted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Wed Feb 14 16:49:35 +0000 2018";
                entities =                 {
                    hashtags =                     (
                        {
                            indices =                             (
                                40,
                                48
                            );
                            text = FARTING;
                    },
                        {
                            indices =                             (
                                49,
                                60
                            );
                            text = clips4sale;
                    }
                    );
                    media =                     (
                        {
                            "display_url" = "pic.twitter.com/Bco1iDrqD6";
                            "expanded_url" = "https://twitter.com/Angiefartland/status/963817507739103233/video/1";
                            id = 963817462121803777;
                            "id_str" = 963817462121803777;
                            indices =                             (
                                73,
                                96
                            );
                            "media_url" = "http://pbs.twimg.com/ext_tw_video_thumb/963817462121803777/pu/img/CSVnKDdEyvSQplCm.jpg";
                            "media_url_https" = "https://pbs.twimg.com/ext_tw_video_thumb/963817462121803777/pu/img/CSVnKDdEyvSQplCm.jpg";
                            sizes =                             {
                                large =                                 {
                                    h = 720;
                                    resize = fit;
                                    w = 1276;
                                };
                                medium =                                 {
                                    h = 677;
                                    resize = fit;
                                    w = 1200;
                                };
                                small =                                 {
                                    h = 384;
                                    resize = fit;
                                    w = 680;
                                };
                                thumb =                                 {
                                    h = 150;
                                    resize = crop;
                                    w = 150;
                                };
                            };
                            type = photo;
                            url = "https://t.co/Bco1iDrqD6";
                        }
                    );
                    symbols =                     (
                    );
                    urls =                     (
                        {
                            "display_url" = "clips4sale.com/100839/19148437";
                            "expanded_url" = "https://clips4sale.com/100839/19148437";
                            indices =                             (
                                16,
                                39
                            );
                            url = "https://t.co/mc3ejPQoQL";
                        }
                    );
                    "user_mentions" =                     (
                        {
                            id = 116881078;
                            "id_str" = 116881078;
                            indices =                             (
                                61,
                                72
                            );
                            name = "Clips4Sale.com";
                            "screen_name" = clips4sale;
                        }
                    );
                };
                "extended_entities" =                 {
                    media =                     (
                        {
                            "additional_media_info" =                             {
                                monetizable = 0;
                            };
                            "display_url" = "pic.twitter.com/Bco1iDrqD6";
                            "expanded_url" = "https://twitter.com/Angiefartland/status/963817507739103233/video/1";
                            id = 963817462121803777;
                            "id_str" = 963817462121803777;
                            indices =                             (
                                73,
                                96
                            );
                            "media_url" = "http://pbs.twimg.com/ext_tw_video_thumb/963817462121803777/pu/img/CSVnKDdEyvSQplCm.jpg";
                            "media_url_https" = "https://pbs.twimg.com/ext_tw_video_thumb/963817462121803777/pu/img/CSVnKDdEyvSQplCm.jpg";
                            sizes =                             {
                                large =                                 {
                                    h = 720;
                                    resize = fit;
                                    w = 1276;
                                };
                                medium =                                 {
                                    h = 677;
                                    resize = fit;
                                    w = 1200;
                                };
                                small =                                 {
                                    h = 384;
                                    resize = fit;
                                    w = 680;
                                };
                                thumb =                                 {
                                    h = 150;
                                    resize = crop;
                                    w = 150;
                                };
                            };
                            type = video;
                            url = "https://t.co/Bco1iDrqD6";
                            "video_info" =                             {
                                "aspect_ratio" =                                 (
                                    319,
                                    180
                                );
                                "duration_millis" = 7000;
                                variants =                                 (
                                    {
                                        bitrate = 2176000;
                                        "content_type" = "video/mp4";
                                        url = "https://video.twimg.com/ext_tw_video/963817462121803777/pu/vid/1276x720/XZr_8cFYT4NXunA_.mp4";
                                },
                                    {
                                        bitrate = 832000;
                                        "content_type" = "video/mp4";
                                        url = "https://video.twimg.com/ext_tw_video/963817462121803777/pu/vid/638x360/zeOHiCJtO9f98jri.mp4";
                                },
                                    {
                                        "content_type" = "application/x-mpegURL";
                                        url = "https://video.twimg.com/ext_tw_video/963817462121803777/pu/pl/-HpVeXWtMIUsrR0w.m3u8";
                                },
                                    {
                                        bitrate = 256000;
                                        "content_type" = "video/mp4";
                                        url = "https://video.twimg.com/ext_tw_video/963817462121803777/pu/vid/318x180/br8mtAVcM8G6_0Fi.mp4";
                                }
                                );
                            };
                        }
                    );
                };
                "favorite_count" = 152;
                favorited = 0;
                geo = "<null>";
                id = 963817507739103233;
                "id_str" = 963817507739103233;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place = "<null>";
                "possibly_sensitive" = 1;
                "retweet_count" = 48;
                retweeted = 0;
                source = "<a href=\"http://twitter.com\" rel=\"nofollow\">Twitter Web Client</a>";
                text = "Gas pregnancy   https://t.co/mc3ejPQoQL #FARTING #clips4sale @clips4sale https://t.co/Bco1iDrqD6";
                truncated = 0;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Fri Mar 13 17:21:53 +0000 2015";
                    "default_profile" = 0;
                    "default_profile_image" = 0;
                    description = "SKYPE SESSION:  live:funwithexc4s\nCONTACT: funwithexc4s@gmail.com";
                    entities =                     {
                        description =                         {
                            urls =                             (
                            );
                        };
                        url =                         {
                            urls =                             (
                                {
                                    "display_url" = "clips4sale.com/100839";
                                    "expanded_url" = "http://clips4sale.com/100839";
                                    indices =                                     (
                                        0,
                                        23
                                    );
                                    url = "https://t.co/IQf9dkpT5h";
                                }
                            );
                        };
                    };
                    "favourites_count" = 291;
                    "follow_request_sent" = 0;
                    "followers_count" = 4961;
                    following = 0;
                    "friends_count" = 148;
                    "geo_enabled" = 0;
                    "has_extended_profile" = 0;
                    id = 3091417000;
                    "id_str" = 3091417000;
                    "is_translation_enabled" = 0;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 16;
                    location = "";
                    name = Angiefartland;
                    notifications = 0;
                    "profile_background_color" = FF6699;
                    "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme11/bg.gif";
                    "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme11/bg.gif";
                    "profile_background_tile" = 1;
                    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/3091417000/1520098160";
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/969537734053453824/NMWDEJZN_normal.jpg";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/969537734053453824/NMWDEJZN_normal.jpg";
                    "profile_link_color" = E81C4F;
                    "profile_sidebar_border_color" = 000000;
                    "profile_sidebar_fill_color" = 000000;
                    "profile_text_color" = 000000;
                    "profile_use_background_image" = 1;
                    protected = 0;
                    "screen_name" = Angiefartland;
                    "statuses_count" = 283;
                    "time_zone" = Belgrade;
                    "translator_type" = none;
                    url = "https://t.co/IQf9dkpT5h";
                    "utc_offset" = 3600;
                    verified = 0;
                };
            };
            source = "<a href=\"http://twitter.com/download/iphone\" rel=\"nofollow\">Twitter for iPhone</a>";
            text = "RT @Angiefartland: Gas pregnancy   https://t.co/mc3ejPQoQL #FARTING #clips4sale @clips4sale https://t.co/Bco1iDrqD6";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Wed Mar 07 10:02:42 +0000 2018";
                "default_profile" = 1;
                "default_profile_image" = 0;
                description = "\U264a\Ufe0f June 8th Sex Addict Freak Single Eproctophilia \Ud83d\Udcaa\Ud83c\Udffe #LongDick Weird";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                };
                "favourites_count" = 0;
                "follow_request_sent" = 0;
                "followers_count" = 0;
                following = 0;
                "friends_count" = 12;
                "geo_enabled" = 0;
                "has_extended_profile" = 1;
                id = 971325258874662912;
                "id_str" = 971325258874662912;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 0;
                location = "Pennsylvania, USA";
                name = "Traevar W";
                notifications = 0;
                "profile_background_color" = F5F8FA;
                "profile_background_image_url" = "<null>";
                "profile_background_image_url_https" = "<null>";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/971325258874662912/1520417175";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/971325983436496896/iC1MSSRE_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/971325983436496896/iC1MSSRE_normal.jpg";
                "profile_link_color" = 1DA1F2;
                "profile_sidebar_border_color" = C0DEED;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = TraevarW;
                "statuses_count" = 6;
                "time_zone" = "<null>";
                "translator_type" = none;
                url = "<null>";
                "utc_offset" = "<null>";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Wed Mar 07 11:32:18 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                );
                "user_mentions" =                 (
                    {
                        id = 190408387;
                        "id_str" = 190408387;
                        indices =                         (
                            3,
                            14
                        );
                        name = ThatPortharcourtBoy;
                        "screen_name" = ThatPHCBoy;
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971347804588314625;
            "id_str" = 971347804588314625;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 4;
            retweeted = 0;
            "retweeted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Wed Mar 07 07:52:16 +0000 2018";
                entities =                 {
                    hashtags =                     (
                    );
                    symbols =                     (
                    );
                    urls =                     (
                        {
                            "display_url" = "twitter.com/i/web/status/9\U2026";
                            "expanded_url" = "https://twitter.com/i/web/status/971292434297696256";
                            indices =                             (
                            117,
                            140
                            );
                            url = "https://t.co/IyQmdzb0CH";
                        }
                    );
                    "user_mentions" =                     (
                    );
                };
                "favorite_count" = 6;
                favorited = 0;
                geo = "<null>";
                id = 971292434297696256;
                "id_str" = 971292434297696256;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place =                 {
                    attributes =                     {
                    };
                    "bounding_box" =                     {
                        coordinates =                         (
                            (
                                (
                                    "7.3116751",
                                    "5.0587562"
                                ),
                                (
                                    "7.4055676",
                                    "5.0587562"
                                ),
                                (
                                    "7.4055676",
                                    "5.1656501"
                                ),
                                (
                                    "7.3116751",
                                    "5.1656501"
                                )
                            )
                        );
                        type = Polygon;
                    };
                    "contained_within" =                     (
                    );
                    country = Nigeria;
                    "country_code" = NG;
                    "full_name" = "Aba, Nigeria";
                    id = 01307b1160a66303;
                    name = Aba;
                    "place_type" = city;
                    url = "https://api.twitter.com/1.1/geo/id/01307b1160a66303.json";
                };
                "retweet_count" = 4;
                retweeted = 0;
                source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
                text = "Men and their pro-life opinions. Dump it in the trash until you develop a uterus and you are able to carry a pregna\U2026 https://t.co/IyQmdzb0CH";
                truncated = 1;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Mon Sep 13 21:51:16 +0000 2010";
                    "default_profile" = 1;
                    "default_profile_image" = 0;
                    description = "Admin of @ThePHCBookClub | Patron Saint of Baby girls | Militant Feminist | Reader | Foodie | Cyclist | Left wing champion of equality | I drag stupidity \Ud83d\Ude12";
                    entities =                     {
                        description =                         {
                            urls =                             (
                            );
                        };
                    };
                    "favourites_count" = 3358;
                    "follow_request_sent" = 0;
                    "followers_count" = 1761;
                    following = 0;
                    "friends_count" = 701;
                    "geo_enabled" = 1;
                    "has_extended_profile" = 1;
                    id = 190408387;
                    "id_str" = 190408387;
                    "is_translation_enabled" = 0;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 57;
                    location = " Nigeria";
                    name = ThatPortharcourtBoy;
                    notifications = 0;
                    "profile_background_color" = C0DEED;
                    "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                    "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                    "profile_background_tile" = 0;
                    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/190408387/1516601327";
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/955321329795911680/zYLhQ_SQ_normal.jpg";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/955321329795911680/zYLhQ_SQ_normal.jpg";
                    "profile_link_color" = 1DA1F2;
                    "profile_sidebar_border_color" = C0DEED;
                    "profile_sidebar_fill_color" = DDEEF6;
                    "profile_text_color" = 333333;
                    "profile_use_background_image" = 1;
                    protected = 0;
                    "screen_name" = ThatPHCBoy;
                    "statuses_count" = 63634;
                    "time_zone" = "<null>";
                    "translator_type" = none;
                    url = "<null>";
                    "utc_offset" = "<null>";
                    verified = 0;
                };
            };
            source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
            text = "RT @ThatPHCBoy: Men and their pro-life opinions. Dump it in the trash until you develop a uterus and you are able to carry a pregnancy!\n\nUn\U2026";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Mon Jul 12 14:31:27 +0000 2010";
                "default_profile" = 0;
                "default_profile_image" = 0;
                description = "Procurement Specialist. Social Media Savvy. Avid Reader. An Aspiring Fashion Stylist Gung-Ho Enthusiast. Nonconformist, Egalitarian, Dance and Yoga.";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                };
                "favourites_count" = 9483;
                "follow_request_sent" = 0;
                "followers_count" = 580;
                following = 0;
                "friends_count" = 1125;
                "geo_enabled" = 1;
                "has_extended_profile" = 0;
                id = 165779277;
                "id_str" = 165779277;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 3;
                location = "Lagos, Nigeria";
                name = "Chikaodili Okoye";
                notifications = 0;
                "profile_background_color" = FFF04D;
                "profile_background_image_url" = "http://pbs.twimg.com/profile_background_images/496224049983266816/kMzTWNxQ.jpeg";
                "profile_background_image_url_https" = "https://pbs.twimg.com/profile_background_images/496224049983266816/kMzTWNxQ.jpeg";
                "profile_background_tile" = 1;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/165779277/1514730234";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/947195407129632768/2wAn2xnI_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/947195407129632768/2wAn2xnI_normal.jpg";
                "profile_link_color" = 19CF86;
                "profile_sidebar_border_color" = FFFFFF;
                "profile_sidebar_fill_color" = F6FFD1;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = ChikaodiliOJ;
                "statuses_count" = 8801;
                "time_zone" = "West Central Africa";
                "translator_type" = none;
                url = "<null>";
                "utc_offset" = 3600;
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Wed Mar 07 11:32:02 +0000 2018";
            entities =             {
                hashtags =                 (
                    {
                        indices =                         (
                            51,
                            61
                        );
                        text = pregnancy;
                },
                    {
                        indices =                         (
                            62,
                            75
                        );
                        text = bodypositive;
                }
                );
                symbols =                 (
                );
                urls =                 (
                    {
                        "display_url" = "buff.ly/2D5Tdwc";
                        "expanded_url" = "https://buff.ly/2D5Tdwc";
                        indices =                         (
                            27,
                            50
                        );
                        url = "https://t.co/vnOt3Db6r9";
                    }
                );
                "user_mentions" =                 (
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971347738221785088;
            "id_str" = 971347738221785088;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "possibly_sensitive" = 0;
            "retweet_count" = 0;
            retweeted = 0;
            source = "<a href=\"http://bufferapp.com\" rel=\"nofollow\">Buffer</a>";
            text = "This writer has had enough https://t.co/vnOt3Db6r9 #pregnancy #bodypositive";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Mon Jul 06 13:27:19 +0000 2009";
                "default_profile" = 0;
                "default_profile_image" = 0;
                description = "The weekly magazine for smart, successful, sophisticated women. Tweets on fashion, beauty, books, food & fun stuff we love.";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                    url =                     {
                        urls =                         (
                            {
                                "display_url" = "stylist.co.uk";
                                "expanded_url" = "http://www.stylist.co.uk";
                                indices =                                 (
                                    0,
                                    23
                                );
                                url = "https://t.co/OJp0ZFCv9f";
                            }
                        );
                    };
                };
                "favourites_count" = 3669;
                "follow_request_sent" = 0;
                "followers_count" = 705543;
                following = 0;
                "friends_count" = 9163;
                "geo_enabled" = 1;
                "has_extended_profile" = 0;
                id = 54203238;
                "id_str" = 54203238;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 3970;
                location = "London, UK";
                name = "Stylist Magazine";
                notifications = 0;
                "profile_background_color" = B67298;
                "profile_background_image_url" = "http://pbs.twimg.com/profile_background_images/689031314431938560/XzHF6gja.jpg";
                "profile_background_image_url_https" = "https://pbs.twimg.com/profile_background_images/689031314431938560/XzHF6gja.jpg";
                "profile_background_tile" = 1;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/54203238/1520352303";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/948197404049924097/IPvw_wQK_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/948197404049924097/IPvw_wQK_normal.jpg";
                "profile_link_color" = 0084B4;
                "profile_sidebar_border_color" = FFFFFF;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = StylistMagazine;
                "statuses_count" = 100575;
                "time_zone" = London;
                "translator_type" = none;
                url = "https://t.co/OJp0ZFCv9f";
                "utc_offset" = 0;
                verified = 1;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Wed Mar 07 11:31:57 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                    {
                        "display_url" = "twitter.com/i/web/status/9\U2026";
                        "expanded_url" = "https://twitter.com/i/web/status/971347720203063301";
                        indices =                         (
                        117,
                        140
                        );
                        url = "https://t.co/lCHlX1LsV5";
                    }
                );
                "user_mentions" =                 (
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971347720203063301;
            "id_str" = 971347720203063301;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 0;
            retweeted = 0;
            source = "<a href=\"http://twitter.com\" rel=\"nofollow\">Twitter Web Client</a>";
            text = "You know shit has hit the fan when you're seeing a high amount of engagement/pregnancy/marriage pictures all over y\U2026 https://t.co/lCHlX1LsV5";
            truncated = 1;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Thu Oct 28 09:09:52 +0000 2010";
                "default_profile" = 0;
                "default_profile_image" = 0;
                description = "24.";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                };
                "favourites_count" = 4227;
                "follow_request_sent" = 0;
                "followers_count" = 591;
                following = 0;
                "friends_count" = 825;
                "geo_enabled" = 1;
                "has_extended_profile" = 1;
                id = 208979364;
                "id_str" = 208979364;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 5;
                location = "London, England";
                name = "Shanice Dunk";
                notifications = 0;
                "profile_background_color" = EBEBEB;
                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme7/bg.gif";
                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme7/bg.gif";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/208979364/1513361113";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/948869287321710594/UwQBzFrC_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/948869287321710594/UwQBzFrC_normal.jpg";
                "profile_link_color" = 990000;
                "profile_sidebar_border_color" = DFDFDF;
                "profile_sidebar_fill_color" = F3F3F3;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = "Mufasa_Dunk";
                "statuses_count" = 13701;
                "time_zone" = Hawaii;
                "translator_type" = none;
                url = "<null>";
                "utc_offset" = "-36000";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Wed Mar 07 11:31:53 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                    {
                        "display_url" = "twitter.com/i/web/status/9\U2026";
                        "expanded_url" = "https://twitter.com/i/web/status/971347700435378186";
                        indices =                         (
                        117,
                        140
                        );
                        url = "https://t.co/44zBHAWEgY";
                    }
                );
                "user_mentions" =                 (
                    {
                        id = 83444823;
                        "id_str" = 83444823;
                        indices =                         (
                            0,
                            15
                        );
                        name = "Sarah\U2b50\Ufe0fHernimanHouse";
                        "screen_name" = cakeybakeytart;
                },
                    {
                        id = 390331099;
                        "id_str" = 390331099;
                        indices =                         (
                            16,
                            32
                        );
                        name = "Social Sparkle";
                        "screen_name" = SocialSparkleUK;
                }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971347700435378186;
            "id_str" = 971347700435378186;
            "in_reply_to_screen_name" = cakeybakeytart;
            "in_reply_to_status_id" = 971346770902110208;
            "in_reply_to_status_id_str" = 971346770902110208;
            "in_reply_to_user_id" = 83444823;
            "in_reply_to_user_id_str" = 83444823;
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 0;
            retweeted = 0;
            source = "<a href=\"http://twitter.com/download/iphone\" rel=\"nofollow\">Twitter for iPhone</a>";
            text = "@cakeybakeytart @SocialSparkleUK yes! this was my 2nd too. It\U2019s almost as tho \U2018real\U2019 people just don\U2019t want to hear\U2026 https://t.co/44zBHAWEgY";
            truncated = 1;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Sat Jan 29 17:13:53 +0000 2011";
                "default_profile" = 1;
                "default_profile_image" = 0;
                description = "Mum of 2, always tired";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                };
                "favourites_count" = 42;
                "follow_request_sent" = 0;
                "followers_count" = 2882;
                following = 0;
                "friends_count" = 4998;
                "geo_enabled" = 0;
                "has_extended_profile" = 0;
                id = 244587336;
                "id_str" = 244587336;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 107;
                location = "Welsh, living in Cheshire";
                name = Jan;
                notifications = 0;
                "profile_background_color" = C0DEED;
                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/244587336/1481740153";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/946285143622344704/URrewrDQ_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/946285143622344704/URrewrDQ_normal.jpg";
                "profile_link_color" = 1DA1F2;
                "profile_sidebar_border_color" = C0DEED;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = JanTweetTweets;
                "statuses_count" = 209262;
                "time_zone" = London;
                "translator_type" = none;
                url = "<null>";
                "utc_offset" = 0;
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Wed Mar 07 11:31:40 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                    {
                        "display_url" = "tribuneonlineng.com/experts-docume\U2026";
                        "expanded_url" = "http://www.tribuneonlineng.com/experts-document-natures-simple-pregnancy-test/";
                        indices =                         (
                        49,
                        72
                        );
                        url = "https://t.co/FHOS42Rl2Q";
                    }
                );
                "user_mentions" =                 (
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971347648602083330;
            "id_str" = 971347648602083330;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "possibly_sensitive" = 0;
            "retweet_count" = 0;
            retweeted = 0;
            source = "<a href=\"http://twitter.com\" rel=\"nofollow\">Twitter Web Client</a>";
            text = "Experts document nature\U2019s simple pregnancy test\n\nhttps://t.co/FHOS42Rl2Q";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Fri Jun 03 15:51:17 +0000 2011";
                "default_profile" = 1;
                "default_profile_image" = 0;
                description = "Unrepentant Nigerian | Sisi's Dad a.k.a Dad to Egbon Awon Twins | Baba Ibeji (In view)";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                };
                "favourites_count" = 873;
                "follow_request_sent" = 0;
                "followers_count" = 9076;
                following = 0;
                "friends_count" = 1485;
                "geo_enabled" = 1;
                "has_extended_profile" = 0;
                id = 310343639;
                "id_str" = 310343639;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 29;
                location = Nigeria;
                name = "Sagay Agbalaya";
                notifications = 0;
                "profile_background_color" = C0DEED;
                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_tile" = 0;
                "profile_image_url" = "http://pbs.twimg.com/profile_images/650969799300902912/XxMytgKv_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/650969799300902912/XxMytgKv_normal.jpg";
                "profile_link_color" = 1DA1F2;
                "profile_sidebar_border_color" = C0DEED;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = sagaysagay;
                "statuses_count" = 53513;
                "time_zone" = "<null>";
                "translator_type" = none;
                url = "<null>";
                "utc_offset" = "<null>";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Wed Mar 07 11:31:35 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                );
                "user_mentions" =                 (
                    {
                        id = 917296288466718720;
                        "id_str" = 917296288466718720;
                        indices =                         (
                            3,
                            12
                        );
                        name = "Daddy Vladimir";
                        "screen_name" = femiTRIP;
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971347627169198081;
            "id_str" = 971347627169198081;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 21;
            retweeted = 0;
            "retweeted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Tue Mar 06 16:28:05 +0000 2018";
                entities =                 {
                    hashtags =                     (
                    );
                    symbols =                     (
                    );
                    urls =                     (
                        {
                            "display_url" = "twitter.com/i/web/status/9\U2026";
                            "expanded_url" = "https://twitter.com/i/web/status/971059853480349697";
                            indices =                             (
                            117,
                            140
                            );
                            url = "https://t.co/CUP3tnQKhv";
                        }
                    );
                    "user_mentions" =                     (
                    );
                };
                "favorite_count" = 23;
                favorited = 0;
                geo = "<null>";
                id = 971059853480349697;
                "id_str" = 971059853480349697;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place = "<null>";
                "retweet_count" = 21;
                retweeted = 0;
                source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
                text = "How do you go through 9 excruciating months of pregnancy and pains of labour and then you name your son Boniface of\U2026 https://t.co/CUP3tnQKhv";
                truncated = 1;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Mon Oct 09 07:50:52 +0000 2017";
                    "default_profile" = 1;
                    "default_profile_image" = 0;
                    description = "Your personal problem || If you do anyhow you go collect {shakabula for head}";
                    entities =                     {
                        description =                         {
                            urls =                             (
                            );
                        };
                    };
                    "favourites_count" = 79;
                    "follow_request_sent" = 0;
                    "followers_count" = 1762;
                    following = 0;
                    "friends_count" = 940;
                    "geo_enabled" = 0;
                    "has_extended_profile" = 1;
                    id = 917296288466718720;
                    "id_str" = 917296288466718720;
                    "is_translation_enabled" = 0;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 10;
                    location = "land of the living. ";
                    name = "Daddy Vladimir";
                    notifications = 0;
                    "profile_background_color" = F5F8FA;
                    "profile_background_image_url" = "<null>";
                    "profile_background_image_url_https" = "<null>";
                    "profile_background_tile" = 0;
                    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/917296288466718720/1510780688";
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/968538071410073600/ZkQCsN4c_normal.jpg";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/968538071410073600/ZkQCsN4c_normal.jpg";
                    "profile_link_color" = 1DA1F2;
                    "profile_sidebar_border_color" = C0DEED;
                    "profile_sidebar_fill_color" = DDEEF6;
                    "profile_text_color" = 333333;
                    "profile_use_background_image" = 1;
                    protected = 0;
                    "screen_name" = femiTRIP;
                    "statuses_count" = 18499;
                    "time_zone" = "<null>";
                    "translator_type" = none;
                    url = "<null>";
                    "utc_offset" = "<null>";
                    verified = 0;
                };
            };
            source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
            text = "RT @femiTRIP: How do you go through 9 excruciating months of pregnancy and pains of labour and then you name your son Boniface of all names\U2026";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Tue Aug 11 14:21:25 +0000 2015";
                "default_profile" = 1;
                "default_profile_image" = 0;
                description = "Politically incorrect. \nI move against the tide.\nThe Bible is my go to for answers.\n\Ud83c\Uddf3\Ud83c\Uddec\Ud83c\Uddf3\Ud83c\Uddec\nNigerian";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                };
                "favourites_count" = 9659;
                "follow_request_sent" = 0;
                "followers_count" = 2132;
                following = 0;
                "friends_count" = 2027;
                "geo_enabled" = 0;
                "has_extended_profile" = 1;
                id = 3415326309;
                "id_str" = 3415326309;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 19;
                location = "";
                name = "Samantha Vou";
                notifications = 0;
                "profile_background_color" = C0DEED;
                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/3415326309/1517257114";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/967540992906809345/HQ03uzw7_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/967540992906809345/HQ03uzw7_normal.jpg";
                "profile_link_color" = 1DA1F2;
                "profile_sidebar_border_color" = C0DEED;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = thedebutante03;
                "statuses_count" = 49268;
                "time_zone" = "<null>";
                "translator_type" = none;
                url = "<null>";
                "utc_offset" = "<null>";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Wed Mar 07 11:31:33 +0000 2018";
            entities =             {
                hashtags =                 (
                    {
                        indices =                         (
                            96,
                            101
                        );
                        text = MAGA;
                },
                    {
                        indices =                         (
                            102,
                            110
                        );
                        text = winning;
                }
                );
                symbols =                 (
                );
                urls =                 (
                );
                "user_mentions" =                 (
                    {
                        id = 72882689;
                        "id_str" = 72882689;
                        indices =                         (
                            3,
                            19
                        );
                        name = "ChainsawBayonet.357";
                        "screen_name" = SonofLiberty357;
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971347615747997696;
            "id_str" = 971347615747997696;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "possibly_sensitive" = 0;
            "retweet_count" = 37;
            retweeted = 0;
            "retweeted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Wed Mar 07 10:06:28 +0000 2018";
                entities =                 {
                    hashtags =                     (
                        {
                            indices =                             (
                                75,
                                80
                            );
                            text = MAGA;
                    },
                        {
                            indices =                             (
                                81,
                                89
                            );
                            text = winning;
                    }
                    );
                    symbols =                     (
                    );
                    urls =                     (
                        {
                            "display_url" = "dailycaller.com/2018/03/06/mic\U2026";
                            "expanded_url" = "http://dailycaller.com/2018/03/06/michigan-family-life-services-planned-parenthood/";
                            indices =                             (
                            97,
                            120
                            );
                            url = "https://t.co/NY4P5rjhdN";
                        }
                    );
                    "user_mentions" =                     (
                    );
                };
                "favorite_count" = 47;
                favorited = 0;
                geo = "<null>";
                id = 971326205113851904;
                "id_str" = 971326205113851904;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place = "<null>";
                "possibly_sensitive" = 1;
                "retweet_count" = 37;
                retweeted = 0;
                source = "<a href=\"http://twitter.com/download/iphone\" rel=\"nofollow\">Twitter for iPhone</a>";
                text = "\Ud83d\Udea8\Ud83d\Udea8 Pro-Life Pregnancy Center Takes Over Former Planned Parenthood Building #MAGA #winning \Ud83d\Udc76\Ud83c\Udffc\Ud83d\Udc76\Ud83c\Udffe\Ud83d\Udc76\Ud83c\Udffd https://t.co/NY4P5rjhdN";
                truncated = 0;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Wed Sep 09 15:50:55 +0000 2009";
                    "default_profile" = 1;
                    "default_profile_image" = 0;
                    description = "Toxically Masculine. Known to eat bacon. Shoot guns/lift heavy objects for fun. High levels of smartassterone. I manterrupt and mansplain. Former TXSG QRT.";
                    entities =                     {
                        description =                         {
                            urls =                             (
                            );
                        };
                        url =                         {
                            urls =                             (
                                {
                                    "display_url" = "SEALfit.com";
                                    "expanded_url" = "http://SEALfit.com";
                                    indices =                                     (
                                        0,
                                        23
                                    );
                                    url = "https://t.co/bwdentxO5v";
                                }
                            );
                        };
                    };
                    "favourites_count" = 17821;
                    "follow_request_sent" = 0;
                    "followers_count" = 71598;
                    following = 0;
                    "friends_count" = 47995;
                    "geo_enabled" = 0;
                    "has_extended_profile" = 1;
                    id = 72882689;
                    "id_str" = 72882689;
                    "is_translation_enabled" = 0;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 580;
                    location = Texas;
                    name = "ChainsawBayonet.357";
                    notifications = 0;
                    "profile_background_color" = C0DEED;
                    "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                    "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                    "profile_background_tile" = 0;
                    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/72882689/1519642693";
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/969000680320131072/nXkjl50V_normal.jpg";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/969000680320131072/nXkjl50V_normal.jpg";
                    "profile_link_color" = 1DA1F2;
                    "profile_sidebar_border_color" = C0DEED;
                    "profile_sidebar_fill_color" = DDEEF6;
                    "profile_text_color" = 333333;
                    "profile_use_background_image" = 1;
                    protected = 0;
                    "screen_name" = SonofLiberty357;
                    "statuses_count" = 435167;
                    "time_zone" = "Central Time (US & Canada)";
                    "translator_type" = none;
                    url = "https://t.co/bwdentxO5v";
                    "utc_offset" = "-21600";
                    verified = 0;
                };
            };
            source = "<a href=\"http://twitter.com/download/iphone\" rel=\"nofollow\">Twitter for iPhone</a>";
            text = "RT @SonofLiberty357: \Ud83d\Udea8\Ud83d\Udea8 Pro-Life Pregnancy Center Takes Over Former Planned Parenthood Building #MAGA #winning \Ud83d\Udc76\Ud83c\Udffc\Ud83d\Udc76\Ud83c\Udffe\Ud83d\Udc76\Ud83c\Udffd https://t.co/NY4P5rjh\U2026";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Wed Jan 17 11:51:10 +0000 2018";
                "default_profile" = 1;
                "default_profile_image" = 0;
                description = "#MAGA #TrumpTrain #DrainTheSwamp Jesus #FLOTUS #POTUS #Winning";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                };
                "favourites_count" = 292;
                "follow_request_sent" = 0;
                "followers_count" = 813;
                following = 0;
                "friends_count" = 1579;
                "geo_enabled" = 0;
                "has_extended_profile" = 0;
                id = 953595546870071297;
                "id_str" = 953595546870071297;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 0;
                location = "";
                name = Winthang;
                notifications = 0;
                "profile_background_color" = F5F8FA;
                "profile_background_image_url" = "<null>";
                "profile_background_image_url_https" = "<null>";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/953595546870071297/1520336718";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/971224113271328768/Y4YIJhS0_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/971224113271328768/Y4YIJhS0_normal.jpg";
                "profile_link_color" = 1DA1F2;
                "profile_sidebar_border_color" = C0DEED;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = AliceWa32036987;
                "statuses_count" = 10305;
                "time_zone" = "<null>";
                "translator_type" = none;
                url = "<null>";
                "utc_offset" = "<null>";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Wed Mar 07 11:31:29 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                );
                "user_mentions" =                 (
                    {
                        id = 1010930449;
                        "id_str" = 1010930449;
                        indices =                         (
                            3,
                            19
                        );
                        name = "The SUN Network";
                        "screen_name" = SUNnetworkCambs;
                },
                    {
                        id = 256504211;
                        "id_str" = 256504211;
                        indices =                         (
                            106,
                            115
                        );
                        name = CPSLMind;
                        "screen_name" = cpslmind;
                }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971347601613258753;
            "id_str" = 971347601613258753;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "possibly_sensitive" = 0;
            "retweet_count" = 3;
            retweeted = 0;
            "retweeted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Mon Mar 05 15:40:01 +0000 2018";
                entities =                 {
                    hashtags =                     (
                    );
                    symbols =                     (
                    );
                    urls =                     (
                        {
                            "display_url" = "twitter.com/i/web/status/9\U2026";
                            "expanded_url" = "https://twitter.com/i/web/status/970685368935833607";
                            indices =                             (
                            117,
                            140
                            );
                            url = "https://t.co/DXtnLG52cq";
                        }
                    );
                    "user_mentions" =                     (
                        {
                            id = 256504211;
                            "id_str" = 256504211;
                            indices =                             (
                                85,
                                94
                            );
                            name = CPSLMind;
                            "screen_name" = cpslmind;
                        }
                    );
                };
                "favorite_count" = 2;
                favorited = 0;
                geo = "<null>";
                id = 970685368935833607;
                "id_str" = 970685368935833607;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place = "<null>";
                "possibly_sensitive" = 0;
                "retweet_count" = 3;
                retweeted = 0;
                source = "<a href=\"http://bufferapp.com\" rel=\"nofollow\">Buffer</a>";
                text = "There's Mums Matter Perinatal Mental Health courses currently running in St Neots by @cpslmind \Ud83e\Udd30\Ud83d\Udc76 Check out the pos\U2026 https://t.co/DXtnLG52cq";
                truncated = 1;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Fri Dec 14 11:08:49 +0000 2012";
                    "default_profile" = 0;
                    "default_profile_image" = 0;
                    description = "We work alongside adults using mental health/drug & alcohol services to get their voice heard & respected, and involve them in decisions involving services.\Ud83e\Udd17";
                    entities =                     {
                        description =                         {
                            urls =                             (
                            );
                        };
                        url =                         {
                            urls =                             (
                                {
                                    "display_url" = "sunnetwork.org.uk";
                                    "expanded_url" = "http://www.sunnetwork.org.uk";
                                    indices =                                     (
                                        0,
                                        23
                                    );
                                    url = "https://t.co/r39OHmMhHs";
                                }
                            );
                        };
                    };
                    "favourites_count" = 440;
                    "follow_request_sent" = 0;
                    "followers_count" = 717;
                    following = 0;
                    "friends_count" = 779;
                    "geo_enabled" = 1;
                    "has_extended_profile" = 0;
                    id = 1010930449;
                    "id_str" = 1010930449;
                    "is_translation_enabled" = 0;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 15;
                    location = Cambridgeshire;
                    name = "The SUN Network";
                    notifications = 0;
                    "profile_background_color" = C0DEED;
                    "profile_background_image_url" = "http://pbs.twimg.com/profile_background_images/453861756285112320/AB2JP40B.jpeg";
                    "profile_background_image_url_https" = "https://pbs.twimg.com/profile_background_images/453861756285112320/AB2JP40B.jpeg";
                    "profile_background_tile" = 0;
                    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/1010930449/1519315207";
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/950404046527098881/GYy2L5nA_normal.jpg";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/950404046527098881/GYy2L5nA_normal.jpg";
                    "profile_link_color" = 1B95E0;
                    "profile_sidebar_border_color" = FFFFFF;
                    "profile_sidebar_fill_color" = DDEEF6;
                    "profile_text_color" = 333333;
                    "profile_use_background_image" = 1;
                    protected = 0;
                    "screen_name" = SUNnetworkCambs;
                    "statuses_count" = 1605;
                    "time_zone" = Amsterdam;
                    "translator_type" = none;
                    url = "https://t.co/r39OHmMhHs";
                    "utc_offset" = 3600;
                    verified = 0;
                };
            };
            source = "<a href=\"http://twitter.com\" rel=\"nofollow\">Twitter Web Client</a>";
            text = "RT @SUNnetworkCambs: There's Mums Matter Perinatal Mental Health courses currently running in St Neots by @cpslmind \Ud83e\Udd30\Ud83d\Udc76 Check out the post o\U2026";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Fri Feb 27 11:02:28 +0000 2009";
                "default_profile" = 0;
                "default_profile_image" = 0;
                description = "Official Twitter account for NHS Cambridgeshire and Peterborough CCG. We are the leader of the local NHS in Cambridgeshire and Peterborough, UK.";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                    url =                     {
                        urls =                         (
                            {
                                "display_url" = "\U2026mbridgeshireandpeterboroughccg.nhs.uk";
                                "expanded_url" = "http://www.cambridgeshireandpeterboroughccg.nhs.uk";
                                indices =                                 (
                                0,
                                23
                                );
                                url = "https://t.co/CiE5ycBo5H";
                            }
                        );
                    };
                };
                "favourites_count" = 159;
                "follow_request_sent" = 0;
                "followers_count" = 9780;
                following = 0;
                "friends_count" = 645;
                "geo_enabled" = 1;
                "has_extended_profile" = 0;
                id = 22129041;
                "id_str" = 22129041;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 317;
                location = "Cambridgeshire, UK";
                name = "Cambs and Pboro CCG";
                notifications = 0;
                "profile_background_color" = 000000;
                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/22129041/1485874538";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/826441654311780352/KvMZQP82_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/826441654311780352/KvMZQP82_normal.jpg";
                "profile_link_color" = 1B95E0;
                "profile_sidebar_border_color" = 000000;
                "profile_sidebar_fill_color" = 000000;
                "profile_text_color" = 000000;
                "profile_use_background_image" = 0;
                protected = 0;
                "screen_name" = CambsPboroCCG;
                "statuses_count" = 7079;
                "time_zone" = London;
                "translator_type" = none;
                url = "https://t.co/CiE5ycBo5H";
                "utc_offset" = 0;
                verified = 1;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Wed Mar 07 11:31:29 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                    {
                        "display_url" = "youtu.be/5hu_-uAfOHw";
                        "expanded_url" = "https://youtu.be/5hu_-uAfOHw";
                        indices =                         (
                            32,
                            55
                        );
                        url = "https://t.co/txlRdM1CYV";
                    }
                );
                "user_mentions" =                 (
                    {
                        id = 10228272;
                        "id_str" = 10228272;
                        indices =                         (
                            60,
                            68
                        );
                        name = YouTube;
                        "screen_name" = YouTube;
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971347600170364928;
            "id_str" = 971347600170364928;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "possibly_sensitive" = 0;
            "retweet_count" = 0;
            retweeted = 0;
            source = "<a href=\"http://twitter.com\" rel=\"nofollow\">Twitter Web Client</a>";
            text = "Tests Used to Confirm Pregnancy https://t.co/txlRdM1CYV via @YouTube";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Tue Oct 24 13:48:39 +0000 2017";
                "default_profile" = 1;
                "default_profile_image" = 0;
                description = "";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                };
                "favourites_count" = 1;
                "follow_request_sent" = 0;
                "followers_count" = 5;
                following = 0;
                "friends_count" = 111;
                "geo_enabled" = 0;
                "has_extended_profile" = 0;
                id = 922822145234763776;
                "id_str" = 922822145234763776;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 0;
                location = "";
                name = "Tech BSE";
                notifications = 0;
                "profile_background_color" = F5F8FA;
                "profile_background_image_url" = "<null>";
                "profile_background_image_url_https" = "<null>";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/922822145234763776/1508856630";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/922824066276368385/o-dlN9hS_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/922824066276368385/o-dlN9hS_normal.jpg";
                "profile_link_color" = 1DA1F2;
                "profile_sidebar_border_color" = C0DEED;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = "tech_bse";
                "statuses_count" = 445;
                "time_zone" = "<null>";
                "translator_type" = none;
                url = "<null>";
                "utc_offset" = "<null>";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Wed Mar 07 11:31:22 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                    {
                        "display_url" = "youtu.be/5hu_-uAfOHw";
                        "expanded_url" = "https://youtu.be/5hu_-uAfOHw";
                        indices =                         (
                            32,
                            55
                        );
                        url = "https://t.co/QR687LAt1v";
                    }
                );
                "user_mentions" =                 (
                    {
                        id = 10228272;
                        "id_str" = 10228272;
                        indices =                         (
                            60,
                            68
                        );
                        name = YouTube;
                        "screen_name" = YouTube;
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971347570818670592;
            "id_str" = 971347570818670592;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "possibly_sensitive" = 0;
            "retweet_count" = 0;
            retweeted = 0;
            source = "<a href=\"http://twitter.com\" rel=\"nofollow\">Twitter Web Client</a>";
            text = "Tests Used to Confirm Pregnancy https://t.co/QR687LAt1v via @YouTube";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Fri Jul 25 09:07:01 +0000 2014";
                "default_profile" = 1;
                "default_profile_image" = 0;
                description = "";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                    url =                     {
                        urls =                         (
                            {
                                "display_url" = "myhomeworkline.blogspot.com";
                                "expanded_url" = "https://myhomeworkline.blogspot.com";
                                indices =                                 (
                                    0,
                                    23
                                );
                                url = "https://t.co/YSTa8y0JMG";
                            }
                        );
                    };
                };
                "favourites_count" = 219;
                "follow_request_sent" = 0;
                "followers_count" = 25;
                following = 0;
                "friends_count" = 468;
                "geo_enabled" = 0;
                "has_extended_profile" = 1;
                id = 2679154555;
                "id_str" = 2679154555;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 0;
                location = "";
                name = "Online Job and Earning";
                notifications = 0;
                "profile_background_color" = C0DEED;
                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/2679154555/1518475938";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/962710419176484865/-DBkwuPD_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/962710419176484865/-DBkwuPD_normal.jpg";
                "profile_link_color" = 1DA1F2;
                "profile_sidebar_border_color" = C0DEED;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = Hossain1308;
                "statuses_count" = 2730;
                "time_zone" = "<null>";
                "translator_type" = none;
                url = "https://t.co/YSTa8y0JMG";
                "utc_offset" = "<null>";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Wed Mar 07 11:31:04 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                );
                "user_mentions" =                 (
                    {
                        id = 912665713491550209;
                        "id_str" = 912665713491550209;
                        indices =                         (
                            3,
                            17
                        );
                        name = "Captain GayFace\U2122\Ufe0f\Ud83c\Udff3\Ufe0f\U200d\Ud83c\Udf08";
                        "screen_name" = LDsquidtastic;
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971347497657470977;
            "id_str" = 971347497657470977;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 8;
            retweeted = 0;
            "retweeted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Wed Mar 07 01:56:16 +0000 2018";
                entities =                 {
                    hashtags =                     (
                    );
                    symbols =                     (
                    );
                    urls =                     (
                        {
                            "display_url" = "twitter.com/i/web/status/9\U2026";
                            "expanded_url" = "https://twitter.com/i/web/status/971202841539940353";
                            indices =                             (
                            117,
                            140
                            );
                            url = "https://t.co/JTRyw1i8FI";
                        }
                    );
                    "user_mentions" =                     (
                    );
                };
                "favorite_count" = 22;
                favorited = 0;
                geo = "<null>";
                id = 971202841539940353;
                "id_str" = 971202841539940353;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place = "<null>";
                "retweet_count" = 8;
                retweeted = 0;
                source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
                text = "My high school sex education was abstinence only. We also had a high pregnancy and std rate. It is ignorant and irr\U2026 https://t.co/JTRyw1i8FI";
                truncated = 1;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Tue Sep 26 13:10:37 +0000 2017";
                    "default_profile" = 1;
                    "default_profile_image" = 0;
                    description = "Bored. Freelance ninja. Love my cat and hashtag games. #LGBTQ proud #lesbian  \Ud83c\Udff3\Ufe0f\U200d\Ud83c\Udf08 #Liberal #Resist #NotMyPresident #BLM  Trolls will be blocked. No DM";
                    entities =                     {
                        description =                         {
                            urls =                             (
                            );
                        };
                    };
                    "favourites_count" = 13191;
                    "follow_request_sent" = 0;
                    "followers_count" = 4586;
                    following = 0;
                    "friends_count" = 4107;
                    "geo_enabled" = 0;
                    "has_extended_profile" = 1;
                    id = 912665713491550209;
                    "id_str" = 912665713491550209;
                    "is_translation_enabled" = 0;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 5;
                    location = "Cincinnati, OH";
                    name = "Captain GayFace\U2122\Ufe0f\Ud83c\Udff3\Ufe0f\U200d\Ud83c\Udf08";
                    notifications = 0;
                    "profile_background_color" = F5F8FA;
                    "profile_background_image_url" = "<null>";
                    "profile_background_image_url_https" = "<null>";
                    "profile_background_tile" = 0;
                    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/912665713491550209/1515279773";
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/960724359747837953/tjGKpk_M_normal.jpg";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/960724359747837953/tjGKpk_M_normal.jpg";
                    "profile_link_color" = 1DA1F2;
                    "profile_sidebar_border_color" = C0DEED;
                    "profile_sidebar_fill_color" = DDEEF6;
                    "profile_text_color" = 333333;
                    "profile_use_background_image" = 1;
                    protected = 0;
                    "screen_name" = LDsquidtastic;
                    "statuses_count" = 9944;
                    "time_zone" = "<null>";
                    "translator_type" = none;
                    url = "<null>";
                    "utc_offset" = "<null>";
                    verified = 0;
                };
            };
            source = "<a href=\"http://twitter.com\" rel=\"nofollow\">Twitter Web Client</a>";
            text = "RT @LDsquidtastic: My high school sex education was abstinence only. We also had a high pregnancy and std rate. It is ignorant and irrespon\U2026";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Sat Jan 30 14:20:31 +0000 2010";
                "default_profile" = 0;
                "default_profile_image" = 0;
                description = "SHOUT From The Mountains & Out 2 The Sea -People Everywhere JUST want to be FREE Iran Syria Russia China Tibet Palestine Burma Cuba & - #TheResistance UniteBlue";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                };
                "favourites_count" = 75823;
                "follow_request_sent" = 0;
                "followers_count" = 20877;
                following = 0;
                "friends_count" = 21037;
                "geo_enabled" = 1;
                "has_extended_profile" = 0;
                id = 109854452;
                "id_str" = 109854452;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 769;
                location = "New York";
                name = ohiomail;
                notifications = 0;
                "profile_background_color" = 9AE4E8;
                "profile_background_image_url" = "http://pbs.twimg.com/profile_background_images/110781384/520ed03b-13be-41a9-8a15-5217e3ce929e.jpg";
                "profile_background_image_url_https" = "https://pbs.twimg.com/profile_background_images/110781384/520ed03b-13be-41a9-8a15-5217e3ce929e.jpg";
                "profile_background_tile" = 0;
                "profile_image_url" = "http://pbs.twimg.com/profile_images/3175272554/1f9bc6b9d84c0553bdbf67f4fd4b1515_normal.png";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/3175272554/1f9bc6b9d84c0553bdbf67f4fd4b1515_normal.png";
                "profile_link_color" = DD2E44;
                "profile_sidebar_border_color" = 87BC44;
                "profile_sidebar_fill_color" = E0FF92;
                "profile_text_color" = 000000;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = ohiomail;
                "statuses_count" = 632146;
                "time_zone" = "Eastern Time (US & Canada)";
                "translator_type" = none;
                url = "<null>";
                "utc_offset" = "-18000";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Wed Mar 07 11:31:04 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                    {
                        "display_url" = "twitter.com/i/web/status/9\U2026";
                        "expanded_url" = "https://twitter.com/i/web/status/971347496239759360";
                        indices =                         (
                        117,
                        140
                        );
                        url = "https://t.co/yPTDMP1fuQ";
                    }
                );
                "user_mentions" =                 (
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971347496239759360;
            "id_str" = 971347496239759360;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "possibly_sensitive" = 0;
            "retweet_count" = 0;
            retweeted = 0;
            source = "<a href=\"https://about.twitter.com/products/tweetdeck\" rel=\"nofollow\">TweetDeck</a>";
            text = "Congratulations to Melissa Simpson, Trust lead on the multi-agency Pregnancy Liaison Meeting (PLM) team and  Doncas\U2026 https://t.co/yPTDMP1fuQ";
            truncated = 1;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Fri Mar 06 15:09:35 +0000 2015";
                "default_profile" = 0;
                "default_profile_image" = 0;
                description = "Providing social care and support for children, young people and families in Doncaster.                                       Monitored Mon-Fri (8.30am-5pm)";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                    url =                     {
                        urls =                         (
                            {
                                "display_url" = "doncasterchildrenstrust.co.uk";
                                "expanded_url" = "http://www.doncasterchildrenstrust.co.uk/";
                                indices =                                 (
                                    0,
                                    22
                                );
                                url = "http://t.co/dkZZztomys";
                            }
                        );
                    };
                };
                "favourites_count" = 2243;
                "follow_request_sent" = 0;
                "followers_count" = 1327;
                following = 0;
                "friends_count" = 817;
                "geo_enabled" = 0;
                "has_extended_profile" = 0;
                id = 3074962917;
                "id_str" = 3074962917;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 27;
                location = Doncaster;
                name = "Don Children's Trust";
                notifications = 0;
                "profile_background_color" = C0DEED;
                "profile_background_image_url" = "http://pbs.twimg.com/profile_background_images/574891909899931649/DUo2T4j8.jpeg";
                "profile_background_image_url_https" = "https://pbs.twimg.com/profile_background_images/574891909899931649/DUo2T4j8.jpeg";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/3074962917/1516367028";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/593341600614502400/zitGTasr_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/593341600614502400/zitGTasr_normal.jpg";
                "profile_link_color" = 0084B4;
                "profile_sidebar_border_color" = C0DEED;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = "DN_Child";
                "statuses_count" = 5440;
                "time_zone" = Dublin;
                "translator_type" = none;
                url = "http://t.co/dkZZztomys";
                "utc_offset" = 0;
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Wed Mar 07 11:30:37 +0000 2018";
            entities =             {
                hashtags =                 (
                    {
                        indices =                         (
                            56,
                            61
                        );
                        text = dads;
                },
                    {
                        indices =                         (
                            87,
                            97
                        );
                        text = pregnancy;
                }
                );
                symbols =                 (
                );
                urls =                 (
                    {
                        "display_url" = "twitter.com/liz_spry/statu\U2026";
                        "expanded_url" = "https://twitter.com/liz_spry/status/971118338167328768";
                        indices =                         (
                        106,
                        129
                        );
                        url = "https://t.co/KuGV6Vxzk5";
                    }
                );
                "user_mentions" =                 (
                    {
                        id = 719851910333886464;
                        "id_str" = 719851910333886464;
                        indices =                         (
                            16,
                            25
                        );
                        name = "Elizabeth Spry";
                        "screen_name" = "liz_spry";
                },
                    {
                        id = 3657075320;
                        "id_str" = 3657075320;
                        indices =                         (
                            98,
                            105
                        );
                        name = CAH;
                        "screen_name" = CforAH;
                }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971347382968266753;
            "id_str" = 971347382968266753;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 1;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "possibly_sensitive" = 0;
            "quoted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Tue Mar 06 20:20:28 +0000 2018";
                entities =                 {
                    hashtags =                     (
                    );
                    symbols =                     (
                    );
                    urls =                     (
                        {
                            "display_url" = "twitter.com/i/web/status/9\U2026";
                            "expanded_url" = "https://twitter.com/i/web/status/971118338167328768";
                            indices =                             (
                            117,
                            140
                            );
                            url = "https://t.co/j8XGE9HYgd";
                        }
                    );
                    "user_mentions" =                     (
                        {
                            id = 2316860300;
                            "id_str" = 2316860300;
                            indices =                             (
                                13,
                                29
                            );
                            name = "Jacinta Parsons";
                            "screen_name" = "Jacinta_Parsons";
                    },
                        {
                            id = 36326202;
                            "id_str" = 36326202;
                            indices =                             (
                                34,
                                43
                            );
                            name = "Sami Cyclops Was Right Shah";
                            "screen_name" = samishah;
                    },
                        {
                            id = 16093222;
                            "id_str" = 16093222;
                            indices =                             (
                                61,
                                74
                            );
                            name = "ABC Melbourne";
                            "screen_name" = abcmelbourne;
                    }
                    );
                };
                "favorite_count" = 12;
                favorited = 0;
                geo = "<null>";
                id = 971118338167328768;
                "id_str" = 971118338167328768;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place = "<null>";
                "possibly_sensitive" = 0;
                "retweet_count" = 3;
                retweeted = 0;
                source = "<a href=\"http://twitter.com/download/iphone\" rel=\"nofollow\">Twitter for iPhone</a>";
                text = "Thank you to @Jacinta_Parsons and @samishah for having me on @abcmelbourne this morning to help shine a spotlight o\U2026 https://t.co/j8XGE9HYgd";
                truncated = 1;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Tue Apr 12 11:37:24 +0000 2016";
                    "default_profile" = 0;
                    "default_profile_image" = 0;
                    description = "Mental health researcher. Working to break intergenerational cycles of mental health problems and help give kids a healthy start to life.";
                    entities =                     {
                        description =                         {
                            urls =                             (
                            );
                        };
                        url =                         {
                            urls =                             (
                                {
                                    "display_url" = "researchgate.net/profile/Elizab\U2026";
                                    "expanded_url" = "https://www.researchgate.net/profile/Elizabeth_Spry";
                                    indices =                                     (
                                    0,
                                    23
                                    );
                                    url = "https://t.co/z5B26oJvYR";
                                }
                            );
                        };
                    };
                    "favourites_count" = 176;
                    "follow_request_sent" = 0;
                    "followers_count" = 71;
                    following = 0;
                    "friends_count" = 195;
                    "geo_enabled" = 0;
                    "has_extended_profile" = 0;
                    id = 719851910333886464;
                    "id_str" = 719851910333886464;
                    "is_translation_enabled" = 0;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 0;
                    location = "Melbourne, Victoria";
                    name = "Elizabeth Spry";
                    notifications = 0;
                    "profile_background_color" = 000000;
                    "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                    "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                    "profile_background_tile" = 0;
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/719852524392427520/eyXvIXam_normal.jpg";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/719852524392427520/eyXvIXam_normal.jpg";
                    "profile_link_color" = 1B95E0;
                    "profile_sidebar_border_color" = 000000;
                    "profile_sidebar_fill_color" = 000000;
                    "profile_text_color" = 000000;
                    "profile_use_background_image" = 0;
                    protected = 0;
                    "screen_name" = "liz_spry";
                    "statuses_count" = 57;
                    "time_zone" = "<null>";
                    "translator_type" = none;
                    url = "https://t.co/z5B26oJvYR";
                    "utc_offset" = "<null>";
                    verified = 0;
                };
            };
            "quoted_status_id" = 971118338167328768;
            "quoted_status_id_str" = 971118338167328768;
            "retweet_count" = 0;
            retweeted = 0;
            source = "<a href=\"http://twitter.com/download/iphone\" rel=\"nofollow\">Twitter for iPhone</a>";
            text = "Congratulations @liz_spry for helping to shine light on #dads and mental health during #pregnancy @CforAH https://t.co/KuGV6Vxzk5";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Tue Aug 18 06:06:34 +0000 2015";
                "default_profile" = 1;
                "default_profile_image" = 0;
                description = "Professor of Adolescent Health University of Melbourne; Commissioner, Lancet Commission on Adolescent Health & Wellbeing; Director, Centre for Adolescent Health";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                };
                "favourites_count" = 137;
                "follow_request_sent" = 0;
                "followers_count" = 864;
                following = 0;
                "friends_count" = 346;
                "geo_enabled" = 0;
                "has_extended_profile" = 0;
                id = 3318402722;
                "id_str" = 3318402722;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 17;
                location = "Melbourne, Australia";
                name = "Susan Sawyer";
                notifications = 0;
                "profile_background_color" = C0DEED;
                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/3318402722/1475024095";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/646244315933487105/oY4XBygY_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/646244315933487105/oY4XBygY_normal.jpg";
                "profile_link_color" = 1DA1F2;
                "profile_sidebar_border_color" = C0DEED;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = susansawyer01;
                "statuses_count" = 921;
                "time_zone" = Melbourne;
                "translator_type" = none;
                url = "<null>";
                "utc_offset" = 39600;
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Wed Mar 07 11:30:29 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                    {
                        "display_url" = "twitter.com/i/web/status/9\U2026";
                        "expanded_url" = "https://twitter.com/i/web/status/971347350068383744";
                        indices =                         (
                        117,
                        140
                        );
                        url = "https://t.co/BxAsvfGA0f";
                    }
                );
                "user_mentions" =                 (
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971347350068383744;
            "id_str" = 971347350068383744;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "possibly_sensitive" = 0;
            "retweet_count" = 0;
            retweeted = 0;
            source = "<a href=\"http://www.hootsuite.com\" rel=\"nofollow\">Hootsuite</a>";
            text = "The stage before pregnancy is very exciting but also the most nervous time of all, our 'Reassurance Scan Package' g\U2026 https://t.co/BxAsvfGA0f";
            truncated = 1;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Sun Jun 09 16:22:26 +0000 2013";
                "default_profile" = 0;
                "default_profile_image" = 0;
                description = "Baby Scan Studio Ashford provides a complete baby scanning service, using cutting edge ultrasound technology to bring images of unborn babies to life in 3D & 4D";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                    url =                     {
                        urls =                         (
                            {
                                "display_url" = "babyscanstudio.com";
                                "expanded_url" = "http://www.babyscanstudio.com";
                                indices =                                 (
                                    0,
                                    22
                                );
                                url = "http://t.co/IUfDJ9sVVj";
                            }
                        );
                    };
                };
                "favourites_count" = 553;
                "follow_request_sent" = 0;
                "followers_count" = 305;
                following = 0;
                "friends_count" = 587;
                "geo_enabled" = 0;
                "has_extended_profile" = 0;
                id = 1496005760;
                "id_str" = 1496005760;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = "en-gb";
                "listed_count" = 4;
                location = "Ashford, Kent";
                name = "Baby Scan Studio";
                notifications = 0;
                "profile_background_color" = 642D8B;
                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme10/bg.gif";
                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme10/bg.gif";
                "profile_background_tile" = 1;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/1496005760/1519643002";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/468676720564781056/jLHIWBGN_normal.png";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/468676720564781056/jLHIWBGN_normal.png";
                "profile_link_color" = 8752A2;
                "profile_sidebar_border_color" = FFFFFF;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = BabyScanAshford;
                "statuses_count" = 1371;
                "time_zone" = London;
                "translator_type" = none;
                url = "http://t.co/IUfDJ9sVVj";
                "utc_offset" = 0;
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Wed Mar 07 11:30:20 +0000 2018";
            entities =             {
                hashtags =                 (
                    {
                        indices =                         (
                            17,
                            25
                        );
                        text = mHealth;
                },
                    {
                        indices =                         (
                            37,
                            46
                        );
                        text = Tanzania;
                },
                    {
                        indices =                         (
                            57,
                            64
                        );
                        text = health;
                }
                );
                symbols =                 (
                );
                urls =                 (
                    {
                        "display_url" = "twitter.com/i/web/status/9\U2026";
                        "expanded_url" = "https://twitter.com/i/web/status/971347309505253377";
                        indices =                         (
                        116,
                        139
                        );
                        url = "https://t.co/ZXoKD9F64G";
                    }
                );
                "user_mentions" =                 (
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971347309505253377;
            "id_str" = 971347309505253377;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "possibly_sensitive" = 0;
            "retweet_count" = 0;
            retweeted = 0;
            source = "<a href=\"http://www.hootsuite.com\" rel=\"nofollow\">Hootsuite</a>";
            text = "How is a leading #mHealth service in #Tanzania improving #health outcomes for the underserved population? Find out\U2026 https://t.co/ZXoKD9F64G";
            truncated = 1;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Tue Oct 31 07:57:09 +0000 2017";
                "default_profile" = 1;
                "default_profile_image" = 0;
                description = "The GSMA unites the mobile industry on the African continent to increase the socio-economic impact of mobile";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                };
                "favourites_count" = 137;
                "follow_request_sent" = 0;
                "followers_count" = 125;
                following = 0;
                "friends_count" = 73;
                "geo_enabled" = 0;
                "has_extended_profile" = 1;
                id = 925270403370704896;
                "id_str" = 925270403370704896;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 0;
                location = "Nairobi, Kenya";
                name = GSMAAfrica;
                notifications = 0;
                "profile_background_color" = F5F8FA;
                "profile_background_image_url" = "<null>";
                "profile_background_image_url_https" = "<null>";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/925270403370704896/1509450844";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/925272330875568129/Vvwm-Iy1_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/925272330875568129/Vvwm-Iy1_normal.jpg";
                "profile_link_color" = 1DA1F2;
                "profile_sidebar_border_color" = C0DEED;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = GSMAAfrica;
                "statuses_count" = 253;
                "time_zone" = "<null>";
                "translator_type" = none;
                url = "<null>";
                "utc_offset" = "<null>";
                verified = 0;
            };
    }
    );
}

 */
