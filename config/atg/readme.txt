As we are creating a big-ear, there is no longer any point in creating a 
development, production, staging, etc directory structure under the 
config/atg tree. In fact this would be detrimental as it would then be
possible to create server directories with the same name under say 
staging and production. Instead we will put att the atg server dirs
in a flat directory and call them dev-store, prod-admin, etc. 