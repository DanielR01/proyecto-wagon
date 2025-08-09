import { Module } from '@nestjs/common';
import { PassportModule } from '@nestjs/passport';
import { FirebaseStrategy } from './firebase.strategy';
import { FirebaseAuthGuard } from './auth.guard';

@Module({
  imports: [
    PassportModule.register({ defaultStrategy: 'firebase' }),
  ],
  providers: [FirebaseStrategy, FirebaseAuthGuard],
  exports: [FirebaseAuthGuard, PassportModule],
})
export class AuthModule {}