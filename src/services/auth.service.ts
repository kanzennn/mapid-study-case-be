import { logger } from '../config/logger';
import { userRepository } from '../repositories/user.repository';
import { AppError } from '../utils/AppError';
import { signToken } from '../utils/jwt';
import { comparePassword, hashPassword } from '../utils/password';
import { sanitizeUser } from '../utils/sanitizeUser';
import { LoginInput, UpdatePasswordInput, UpdateProfileInput } from '../validations/auth.validation';

export const authService = {
  async login(input: LoginInput) {
    const user = await userRepository.findByEmail(input.email);

    if (!user) {
      logger.warn({ event: 'login_failed', email: input.email }, 'Login failed: invalid credentials');
      throw new AppError('Invalid email or password', 401);
    }

    const isValidPassword = await comparePassword(
      input.password,
      user.password,
    );

    if (!isValidPassword) {
      logger.warn({ event: 'login_failed', email: input.email }, 'Login failed: invalid credentials');
      throw new AppError('Invalid email or password', 401);
    }

    if (!user.is_active) {
      logger.warn({ event: 'login_failed', userId: user.id, reason: 'inactive' }, 'Login failed: account deactivated');
      throw new AppError('Your account has been deactivated', 401);
    }

    logger.info({ event: 'login_success', userId: user.id }, 'Login succeeded');

    const token = signToken({ userId: user.id, role: user.role });
    return { user: sanitizeUser(user), token };
  },

  async updateProfile(id: string, input: UpdateProfileInput) {
    const updated = await userRepository.update(id, input);
    return sanitizeUser(updated);
  },

  async updatePassword(id: string, input: UpdatePasswordInput) {
    const user = await userRepository.findById(id);
    if (!user) {
      throw new AppError('User not found', 404);
    }

    const isValidPassword = await comparePassword(input.currentPassword, user.password);
    if (!isValidPassword) {
      throw new AppError('Current password is incorrect', 400);
    }

    if (input.newPassword === input.currentPassword) {
      throw new AppError('New password must be different from the current password', 400);
    }

    const hashedPassword = await hashPassword(input.newPassword);
    await userRepository.update(id, { password: hashedPassword });
  },
};
