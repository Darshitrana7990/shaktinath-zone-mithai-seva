# Shaktinath Zone Mithai Seva-2026 — Online Website Starter

આ project Android, iPhone અને Windows browser પર responsive રીતે ચાલે છે. એક જ Supabase cloud database વાપરવાથી signed-in devices વચ્ચે data share થાય છે.

## હાલ શું તૈયાર છે
- Email + password login (Supabase Auth)
- Admin / Staff role framework
- Dashboard: net sales, collected, pending, transaction count
- Sales અને Returns entry
- Cash / Online / Mixed payment; partial payment અને pending calculation
- Customer list અને customer-wise pending summary
- Product list અને admin-only product management
- Transaction search
- Excel અને PDF report export
- PWA manifest (browser માં Add to Home Screen માટે)

## Online ચાલુ કરવા માટે જરૂરી પગલાં
1. Supabase પર નવો project બનાવો: https://supabase.com/dashboard
2. Supabase > SQL Editor માં `supabase-schema.sql` ની સંપૂર્ણ script run કરો.
3. Supabase > Authentication > Users માં admin user બનાવો. Admin email અને password તમે નક્કી કરો. અગાઉ નક્કી કરેલો `Sarvam@1708` password admin account માટે મૂકી શકો છો.
4. તે user નો UUID copy કરો. SQL Editor માં આ ચલાવો:
   `insert into public.profiles(id, role, display_name) values ('PASTE-USER-UUID','admin','Administrator');`
5. બીજા user ને Authentication > Users માં બનાવો અને profiles માં `role='staff'` સાથે insert કરો.
6. Project Settings > API માંથી Project URL અને publishable/anon key લો. `.env.example` ને `.env` નામે copy કરી values भरो.
7. Terminal માં `npm install` અને `npm run build` ચલાવો. પછી Vercel પર project deploy કરો અને એ જ બે environment variables Vercel project settings માં ઉમેરો.

## મહત્વની સુરક્ષા સૂચનાઓ
- Supabase `service_role` / secret key ક્યારેય browser app, `.env` client variable અથવા Vercel public environment માં ન મૂકો. ફક્ત publishable/anon key જ frontend માં વાપરો.
- Admin password આ code માં hardcode કરેલો નથી. Supabase Authentication માં જ સેટ કરવો.
- Database project નું backup Supabase માંથી નિયમિત લો.
- આ starter માં transaction entry, returns અને partial collection છે. અલગથી હપ્તાવાર payment collection/adjustment, stock/inventory, audit log અને advanced date filters ઉમેરવાના બાકી છે.

## Local test
`npm install`
`cp .env.example .env`  (Windows પર ફાઇલની copy બનાવી `.env` નામ આપો)
`npm run dev`
