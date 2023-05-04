-- this file was manually created
INSERT INTO public.users (display_name, email, handle, cognito_user_id)
VALUES
  ('Marie', 'katelyn.nettles@gmail.com', 'Marie', 'MOCK'),
  ('kate nettles', 'katelyn_nett06@yahoo.com', 'katenettles', 'MOCK');


INSERT INTO public.activities (user_uuid, message, expires_at)
VALUES
  (
    (SELECT uuid from public.users WHERE users.handle = 'katenettles' LIMIT 1),
    'This was imported as seed data!',
    current_timestamp + interval '10 day'
  )