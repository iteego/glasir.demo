/*
 * Copyright (c) 2011. Iteego.
 */



package com.iteego.db

import java.security.spec.X509EncodedKeySpec
import java.security.KeyFactory
import java.security.PublicKey
import java.security.Signature

/**
 * Perform License validation in an ATG context.
 */

final class LicenseHandler {
  AtgLogHelper log

  //----------------------------------------------------------------
  // license properties
  //----------------------------------------------------------------
  Boolean licenseDevelopment = true
  String licenseStartDate         // First valid date
  String licenseExpiryDate        // Last valid date
  String licenseLicensee          // Identifying the customer
  String licenseProduct
  String licenseMacLock           // For hardware locking
  String licenseKey               // Iteego's public key, used to validate license hash value
  String licenseSignature

  final List<String> licenseProperties =
      // propertyName
      ['licenseStartDate',
      'licenseExpiryDate',
      'licenseDevelopment',
      'licenseLicensee',
      'licenseProduct',
      'licenseSignature'] as List<String>

  final List<String> skipInPlaintext =
      // propertyName
      ['licenseSignature'] as List<String>



  //----------------------------------------------------------------
  // validation values
  //----------------------------------------------------------------
  private String licenseHash      // encrypted (with iteego private key) hash of license properties
  private String classHash        // encrypted (with iteego private key) hash of this class

  //----------------------------------------------------------------
  // constants
  //----------------------------------------------------------------
  private static final char[] DIGITS_LOWER = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'];
  private static final char[] DIGITS_UPPER = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];
  static final String DATE_FORMAT = "yyyy-MM-dd" // As used in license files.

  //----------------------------------------------------------------
  // methods
  //----------------------------------------------------------------

  public LicenseHandler( AtgLogHelper logger = null ) {
    this.log = logger
  }

  /**
   * Validate the license properties and signature.
   */
  void validateLicense( String product ) {
    // Verify that the signature was created by Iteego's private key.
    validateSignature()

    // Verify that the license values are valid.
    validateLicenseValues( product )
  }


  String generatePlainText() {
    String plainText = LicenseHandler.generatePlainText(
        licenseStartDate,
        licenseExpiryDate,
        licenseLicensee,
        licenseProduct,
        licenseDevelopment )
    return plainText
  }

  static String generatePlainText( String licenseStartDate, String licenseExpiryDate, String licenseLicensee, String licenseProduct, Boolean licenseDevelopment ) {
    StringBuilder stringBuilder = new StringBuilder();
    stringBuilder.append( "licenseStartDate:" + licenseStartDate + "," );
    stringBuilder.append( "licenseExpiryDate:" + licenseExpiryDate + "," );
    stringBuilder.append( "licenseDevelopment:" + licenseDevelopment?.toString()?.toLowerCase() + "," );
    stringBuilder.append( "licenseLicensee:" + licenseLicensee + "," );
    stringBuilder.append( "licenseProduct:" + licenseProduct );
    return stringBuilder.toString()
  }


  public void validateSignature() {
    licenseKey = licenseKey ?: "308201B83082012C06072A8648CE3804013082011F02818100FD7F53811D75122952DF4A9C2EECE4E7F611B7523CEF4400C31E3F80B6512669455D402251FB593D8D58FABFC5F5BA30F6CB9B556CD7813B801D346FF26660B76B9950A5A49F9FE8047B1022C24FBBA9D7FEB7C61BF83B57E7C6A8A6150F04FB83F6D3C51EC3023554135A169132F675F3AE2B61D72AEFF22203199DD14801C70215009760508F15230BCCB292B982A2EB840BF0581CF502818100F7E1A085D69B3DDECBBCAB5C36B857B97994AFBBFA3AEA82F9574C0B3D0782675159578EBAD4594FE67107108180B449167123E84C281613B7CF09328CC8A6E13C167A8B547C8D28E0A3AE1E2BB3A675916EA37F0BFA213562F1FB627A01243BCCA4F1BEA8519089A883DFE15AE59F06928B665E807B552564014C3BFECF492A0381850002818100D4117D4BB00FD62BF33234EFF8423B97F3826C18B75503A377E7D6E633A1A1E430D6427BDE7F4999D551587DE0B669B46EACC3425A218030BD73A0DC666E84C9629E15B3B43EC81E4B3DCB0C522B353C0EB09574C11DD502B3B98FF64A139707E0C846FE11E535ABCF386B38864346E176DFA32BD11FE8DB5E8ED5142C522E07"
    byte[] key = LicenseHandler.decode( licenseKey )
    byte[] sig = LicenseHandler.decode( licenseSignature  )
    LicenseHandler.validateSignature( generatePlainText(), key, sig )
  }

  /**
   * Calculate and compare a hash of the plain-text to the decrypted value of the signature.
   * This guarantees that the signature was created by the corresponding (and top secret to
   * anyone except Iteego) private key.
   * @param plainText The Document.
   * @param publicBytes The Public Key.
   * @param signatureBytes The Signature to be verified.
   */
  public static void validateSignature( String plainText, byte[] publicBytes, byte[] signatureBytes) {
    X509EncodedKeySpec pubKeySpec = new X509EncodedKeySpec( publicBytes )
    KeyFactory keyFactory = KeyFactory.getInstance( "DSA", "SUN" )
    PublicKey pubKey = keyFactory.generatePublic( pubKeySpec )

    Signature dsaVerification = Signature.getInstance("SHA/DSA")
    dsaVerification.initVerify( pubKey )
    dsaVerification.update( plainText.getBytes("utf-8") )

    // verification
    //noinspection GroovyEmptyStatementBody
    if( !dsaVerification.verify( signatureBytes ) ) {
      String message = "License signature validation failed. Contact support@iteego.com (www.iteego.com)."
      throw new Exception( message )
    } else {
      //println "License validation OK"
    }
  }

  public void validateLicenseValues( String expectedProduct ) {
    LicenseHandler.validateLicenseValues(
        log,
        licenseStartDate,
        licenseExpiryDate,
        licenseLicensee,
        licenseProduct,
        licenseDevelopment )

    if( !expectedProduct?.equalsIgnoreCase( licenseProduct ) ) {
      throw new Exception( "Incorrect product: expected \"$expectedProduct\", found \"$licenseProduct\". " )
    }
  }

  /**
   * Throws exception if there is something wrong with the license values, such as an expired date.
   * @param log Will be used if present, null is accepted.
   * @param licenseStartDate License property.
   * @param licenseExpiryDate License property.
   * @param licenseLicensee License property.
   * @param licenseProduct License property.
   * @param licenseDevelopment License property.
   */
  public static void validateLicenseValues( AtgLogHelper log, String licenseStartDate, String licenseExpiryDate, String licenseLicensee, String licenseProduct, Boolean licenseDevelopment ) {
    //--------------------------------------------------------------
    // Verify that the license values are valid.
    //--------------------------------------------------------------
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat( LicenseHandler.DATE_FORMAT );
    Date now = Calendar.getInstance( TimeZone.getTimeZone("GMT") ).time
    Date startDate = sdf.parse( licenseStartDate )
    Date expiryDate = sdf.parse( licenseExpiryDate )
    Boolean development = licenseDevelopment
    String licensee = licenseLicensee

    log?.info( "$licenseProduct license belongs to $licensee" )
    log?.info( "$licenseProduct license is valid from '$startDate' till '$expiryDate'" )

    if( now.after(expiryDate) || now.before(startDate) ) {
      throw new Exception( "License fails date test." )
    } else {
      log?.debug( "License passes date test." )
    }

    if( development ) {
      log?.info( "ATG_DB license is for Development use only.")
    }
  }


  public static byte[] decodeHex(char[] data) {
    int len = data.length;

    if( (len & 0x01) != 0 ) {
      throw new Exception("Odd number of characters in data is not allowed.");
    }

    byte[] out = new byte[len >> 1];

    // two characters form the hex value.
    int i = 0
    int j
    for( j = 0; j < len; i++ ) {
      int f = toDigit(data[ j ], j) << 4;
      j++;
      f = f | toDigit(data[ j ], j);
      j++;
      out[ i ] = (byte) (f & 0xFF);
    }

    return out;
  }

  public static char[] encodeHex(byte[] data, char[] toDigits) {
    println "toDigits = $toDigits"
    int l = data.length;
    char[] out = new char[l << 1];
    // two characters form the hex value.
    int i
    int j = 0
    for( i = 0; i < l; i++ ) {
      byte hi = (0xF0 & data[ i ])
      byte lo = (0x0F & data[ i ])
      byte shiftedHi = hi >>> 4
      println "shiftedHi = $shiftedHi "
      out[ j++ ] = toDigits[ (byte) shiftedHi ];
      out[ j++ ] = toDigits[ lo ];
    }
    return out;
  }

  public static int toDigit(char ch, int index) {
    int digit = Character.digit(ch, 16);
    if( digit == -1 ) {
      throw new Exception("Illegal hexadecimal character " + ch + " at index " + index);
    }
    return digit;
  }

  public static String encodeHexString(byte[] data) {
    return new String(encodeHex(data));
  }


  public static Object encode(Object object) {
    try {
      byte[] byteArray = object instanceof String ? ((String) object).getBytes("utf-8") : (byte[]) object;
      return encodeHex(byteArray);
    }
    catch (ClassCastException e) {
      throw new Exception(e.getMessage(), e);
    }
    catch (UnsupportedEncodingException e) {
      throw new Exception(e.getMessage(), e);
    }
  }

  public static char[] encodeHex(byte[] data) {
    return encodeHex(data, false);
  }

  public static char[] encodeHex(byte[] data, boolean toLowerCase) {
    return encodeHex(data, toLowerCase ? LicenseHandler.DIGITS_LOWER : LicenseHandler.DIGITS_UPPER);
  }

  public static byte[] decode(byte[] array) {
    try {
      return decodeHex(new String(array, "utf-8").toCharArray());
    }
    catch (UnsupportedEncodingException e) {
      throw new Exception(e.getMessage(), e);
    }
  }

  public static Object decode(Object object) {
    try {
      char[] charArray = object instanceof String ? ((String) object).toCharArray() : (char[]) object;
      return decodeHex(charArray);
    }
    catch (ClassCastException e) {
      throw new Exception(e.getMessage(), e);
    }
  }

}