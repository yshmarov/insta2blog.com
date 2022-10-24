## [insta2blog.com](https://insta2blog.com)

### ⁉️ Why did I create this?

A few days ago wife `@za.yuliia` was banned from instagram for her 🇺🇦 posts. There was no indication that her account would be restored. She felt awful about it, because she had spent a lot of time creating her page, her posts. Hopefully this tool would give her a reliable data backup that is easy to access.

Another reason would be my sister `@alisa.shmarova` is trying to be a blogger. She writes a lot of useful posts about travelling to different cities. Content on instagram is not searchable and is short-lived. The posts she writes are evergreen. Having a blog would let her content be evergreen and searchable.

Initially I was inspired with this idea after hearing of some guy who created "Sheets2Site".

### 💡 Value proposition

This is a media channel that you completely own. Your own auto-generated website.

Share urls to your posts on the blog to drive traffic to your website. 

### ✔️ Core features

The application let's you "download" a snapshot of your instagram account on a regular basis.

You can search for posts content in the local copy of the account.

### 🤯 Instagram Basic Display API

Flow of connecting and using Instagram Basic Display API:

1. Get token
* authorization window
* successfull authorization gives an access `code`
* access `code` is exchanged for a `short_lived_access_token` (60 min valid)
* `short_lived_access_token` is exchanged for a `long_lived_access_token` (60 days valid)

2. Get data
`long_lived_access_token` can be used to get:
* user profile data (`username`, `media_count`)
* detailed `user_media` data

3. Refresh token
`long_lived_access_token` should be refreshed every 59 days.

API limitations: it does not get
* user avatar
* user description
* user website
* media comments
* media likes
* media location
* media stories

### 💻 Tech stack

* ruby 3
* rails 7
* tailwind 3
* importmap-rails
* StimulusJS
* Hotwire/Turbo
* minitest
* sidekiq (coming soon)
* AWS S3 (coming soon)

### 🚀 Start the app

Clone app, start server

```shell
git clone git@github.com:yshmarov/insta2blog.com.git
cd insta2blog.com
bundle
rails db:setup
bin/dev
```

To properly use the app, you will need valid Instagram basic display API keys.

Add them to your credentials file. Example:

```yml
# credentials.yml
instagram:
  client_id: 123
  client_secret: abc123
```

The app uses gem data-migrate. To run data migrations together with regular ones:

```ruby
rails db:migrate:with_data
```

### 🤝 Contributing

[Check the dev roadmap](https://github.com/users/yshmarov/projects/2)

Got an idea 💡? [Open an issue](https://github.com/yshmarov/insta2blog.com/issues/new).

If you create a PR (if you can), preferably with tests 🙏.

### Thanks for taking your time, wanderer!
