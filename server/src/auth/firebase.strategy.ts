import { PassportStrategy } from '@nestjs/passport';
import { Injectable, UnauthorizedException, Logger } from '@nestjs/common';
import { Strategy } from 'passport-http-bearer';
import * as admin from 'firebase-admin';

@Injectable()
export class FirebaseStrategy extends PassportStrategy(Strategy, 'firebase') {
  private readonly logger = new Logger(FirebaseStrategy.name);

  constructor() {
    super();
    this.initializeFirebase();
  }

  private initializeFirebase() {
    if (!admin.apps.length) {
      this.logger.log('Initializing Firebase Admin SDK...');

      if (!process.env.FIREBASE_SERVICE_ACCOUNT) {
        throw new Error('FIREBASE_SERVICE_ACCOUNT environment variable not set.');
      }

      const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);

      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
      });
    }
  }

  async validate(token: string) {
    this.logger.debug('Attempting to validate bearer token...');
    try {
      const decodedToken = await admin.auth().verifyIdToken(token);
      this.logger.log(`Token validated successfully for UID: ${decodedToken.uid}`);
      return decodedToken;
    } catch (error) {
      this.logger.error('Firebase token verification failed:', error.message);
      throw new UnauthorizedException(
        'Authentication failed. The token is invalid, expired, or malformed.',
      );
    }
  }
}
