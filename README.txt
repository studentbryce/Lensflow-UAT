
LensFlow UAT + SUS standalone page

Files:
- index.html : Two-tab UAT/SUS tester page
- schema.sql : Supabase PostgreSQL schema and RLS policy

Setup:
1. Prefer a separate Supabase project for this research form.
2. In Supabase SQL Editor, run schema.sql.
3. In index.html replace YOUR_SUPABASE_PROJECT_URL and
   YOUR_SUPABASE_PUBLISHABLE_OR_ANON_KEY with the project's public values.
   NEVER use the service_role key or a secret key in browser code.
4. Host index.html on any HTTPS static host (e.g. Vercel or Netlify).
5. Test a full submission using fictional data. Inspect results privately
   in Supabase Table Editor or SQL Editor.

Notes:
- The form submits UAT and SUS together at the end. Switching tabs
  does not save data to the server; closing/reloading the page loses entries.
- All 12 task statuses and 10 SUS answers are required; Not tested is valid.
- SUS is scored server-side (0-100) using the standard alternating formula.
- Anonymous inserts are open to anyone with the page URL and can be spammed.
  For wider public use, add CAPTCHA/rate limiting via a backend or Edge Function.
- The browser cannot read stored submissions. Do not expose respondent data.
- This form does not replace the separate stakeholder acceptance sign-off.

FRESH-ACCOUNT UAT UPDATE (2026-10-26)
- Four test logins and shared password appear on the UAT webpage.
- Tasks 1-12 now begin with empty accounts and create prerequisite service, availability, booking, invoice and gallery data in order.
- Use Photographer A + Client A (Studio One) by default, or B + B (Studio Two) if assigned.
- SUS wording, question order, UAT task IDs and Supabase submission payload/schema remain unchanged.
- The UAT webpage contains the shared test password in its HTML; publish only for authorised testers and rotate/remove the credentials after testing.
- Supply the deployed LensFlow application URL to testers separately; it was not included in the supplied archive.
- Shared accounts are not independent per participant. Run sessions sequentially or reset data between sessions for a genuine first-use experience.
