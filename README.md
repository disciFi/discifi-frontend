# DisciFi (Disciplined Finance)
your money’s in good hands - daddy’s here.

this is the *flutter front-end* for **DisciFi**. 
the application helps you track your finances and also *roasts* you over your bad financial decisions as well as *praises & motivates* you over your good financial endeavours.

purpose:
- track finances with multiple accounts and customizable budgets.
- surface data and collect user inputs.
- generate insights using AI - both auto and on-demand.
- helps user build financial discipline via feedback loops and nudges.

> note: this is a rough base level idea of what the application offers. may modify things over the course of further development.

features (completed):
1. authentication: jwt-based authentication, persist over longer sessions. 
2. *3-part* dashboard summary (today, week and month).
3. mess up with transactions, budgets, accounts, etc.
4. auto insights (over activity in the course of some defined period).

features (in-progress): 
- [ ] on-demand insights (if user wants to get scolded or praised over some custom activity).
- [ ] intensity slider (basically asking AI to be whether your hitler daddy or teddy bear daddy).
- [ ] word cloud
*(haven't a listed a lot of others which are currently dangling in my mind)*

used:
- `flutter (dart sdk ≥ 3.7.2)`
- state management: `riverpod`
- http client: `dio`
- `flutter_secure_storage` for jwt storage
- `intl` for formatting and localisation

setup & run:
```
git clone https://github.com/disciFi/discifi-frontend.git
cd discifi-frontend
flutter pub get
flutter run
```
update the base URL in lib/core/api/api_service.dart to use the backend.