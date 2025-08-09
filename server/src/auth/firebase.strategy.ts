import { PassportStrategy } from '@nestjs/passport';
import { Injectable, UnauthorizedException, Logger } from '@nestjs/common';
import { Strategy } from 'passport-http-bearer';
import * as admin from 'firebase-admin';
import * as path from 'path';

@Injectable()
export class FirebaseStrategy extends PassportStrategy(Strategy, 'firebase') {
  private readonly logger = new Logger(FirebaseStrategy.name);

  constructor() {
    super();
    if (!admin.apps.length) {
      this.logger.log('Initializing Firebase Admin SDK...');
      const serviceAccount = require(path.join(
        __dirname,
        '..',
        '..',
        'firebase-service-account.json',
      ));
      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
      });
    }
  }

  /**
   * This method is called automatically by Passport.
   * The 'passport-http-bearer' strategy extracts the token from the 'Authorization' header.
   * @param token The raw JWT string sent by the client.
   * @returns The decoded user object if the token is valid.
   */
  async validate(token: string) {
    this.logger.debug('Attempting to validate bearer token...');
    try {
      const decodedToken = await admin.auth().verifyIdToken(token);

      this.logger.log(`Token validated successfully for UID: ${decodedToken.uid}`);
      
      // The object returned here will be injected into `request.user`.
      return decodedToken;

    } catch (error) {
      this.logger.error('Firebase token verification failed:', error.message);
      throw new UnauthorizedException(
        'Authentication failed. The token is invalid, expired, or malformed.',
      );
    }
  }
}