/*
  # Create users table for InvoiceSync authentication

  1. New Tables
    - `users`
      - `id` (uuid, primary key) - Unique user identifier
      - `email` (text, unique, not null) - User email address
      - `password_hash` (text, not null) - Hashed password for secure storage
      - `created_at` (timestamptz) - Account creation timestamp
      - `updated_at` (timestamptz) - Last update timestamp

  2. Security
    - Enable RLS on `users` table
    - Add policy for authenticated users to read their own data
    - Add policy for authenticated users to update their own data

  3. Important Notes
    - Passwords will be hashed using bcrypt before storage
    - Email addresses are unique to prevent duplicate accounts
    - RLS policies ensure users can only access their own data
*/

CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  password_hash text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own data"
  ON users
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update own data"
  ON users
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);